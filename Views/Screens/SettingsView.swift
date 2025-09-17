import SwiftUI
import UserNotifications

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel

    // alert, если доступ запрещён
    @State private var showNotificationsDeniedAlert = false
    // отслеживаем возврат из Настроек
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            (themeViewModel.currentTheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Настройки")
                    .font(.largeTitle)
                    .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                    .padding()

                // Тема
                Toggle(isOn: $themeViewModel.isDarkMode) {
                    Text("Темная тема")
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                }
                .padding()

                // Уведомления
                Toggle(isOn: $viewModel.settings.notificationsEnabled) {
                    Text("Уведомления")
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                }
                .padding()
                .onChange(of: viewModel.settings.notificationsEnabled) { isOn in
                    viewModel.toggleNotifications()
                    UserDefaults.standard.set(isOn, forKey: "notificationsEnabled")

                    if isOn {
                        NotificationManager.requestAuthorizationIfNeeded { granted in
                            if granted {
                                Task { try? await NotificationManager.scheduleDaily(at: 9, minute: 0) }
                            } else {
                                // возвращаем тумблер в OFF и предлагаем открыть Настройки
                                DispatchQueue.main.async {
                                    viewModel.settings.notificationsEnabled = false
                                    UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                                    showNotificationsDeniedAlert = true
                                }
                            }
                        }
                    } else {
                        NotificationManager.cancelDaily()
                    }
                }

                #if DEBUG
                Button("Тест уведомления (10 сек)") {
                    NotificationManager.scheduleTest(after: 10)
                }
                .padding(.top, 8)
                #endif

                // Модель Apple Watch
                Picker("Выберите модель Apple Watch", selection: $viewModel.settings.selectedDevice) {
                    ForEach(viewModel.appleWatchModels, id: \.self) { device in
                        Text(device).tag(device)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                .onChange(of: viewModel.settings.selectedDevice) { newDevice in
                    viewModel.selectDevice(newDevice)
                }

                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(themeViewModel.currentTheme)
        // синхронизируемся при старте и возврате в приложение (например, после Настроек)
        .onAppear {
            let enabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
            viewModel.settings.notificationsEnabled = enabled
            NotificationManager.authorizationStatus { status in
                let allowed = (status == .authorized || status == .provisional || status == .ephemeral)
                if allowed && enabled {
                    NotificationManager.sync(enabled: true)   // перепланируем на всякий случай
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            // пользователь мог вернуться из Настроек → проверим статус
            NotificationManager.authorizationStatus { status in
                let allowed = (status == .authorized || status == .provisional || status == .ephemeral)
                let wants = viewModel.settings.notificationsEnabled
                NotificationManager.sync(enabled: allowed && wants)
            }
        }
        // алерт при отказе
        .alert("Уведомления отключены", isPresented: $showNotificationsDeniedAlert) {
            Button("Открыть настройки") {
                NotificationManager.openAppSettings()
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Чтобы получать напоминания в 09:00, включите уведомления для приложения в Настройках.")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeViewModel())
    }
}

