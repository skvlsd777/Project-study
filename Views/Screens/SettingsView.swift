import SwiftUI
import UserNotifications

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel

    // Глобально сохраняем/читаем выбранную модель для использования в CustomView
    @AppStorage("selectedDevice") private var selectedDeviceName: String = "Apple Watch Series 8"

    // alert, если доступ к уведомлениям запрещён
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
                    .padding(.top)

                // Тёмная тема
                Toggle(isOn: $themeViewModel.isDarkMode) {
                    Text("Тёмная тема")
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                }
                .padding(.horizontal)

                // Уведомления (ежедневно в 09:00)
                Toggle(isOn: $viewModel.settings.notificationsEnabled) {
                    Text("Уведомления")
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                }
                .padding(.horizontal)
                .onChange(of: viewModel.settings.notificationsEnabled) { isOn in
                    // Сохраняем флаг и настраиваем уведомления
                    UserDefaults.standard.set(isOn, forKey: "notificationsEnabled")

                    if isOn {
                        NotificationManager.requestAuthorizationIfNeeded { granted in
                            if granted {
                                Task { try? await NotificationManager.scheduleDaily(at: 9, minute: 0) }
                            } else {
                                // Возврат тумблера в OFF и предложение открыть Настройки
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
                .padding(.top, 4)
                #endif

                // Выбор модели Apple Watch (сохраняем в @AppStorage)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Модель Apple Watch")
                        .font(.headline)
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)

                    Picker("Выберите модель Apple Watch", selection: $selectedDeviceName) {
                        ForEach(viewModel.appleWatchModels, id: \.self) { device in
                            Text(device).tag(device)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxHeight: 160)
                    .clipped()
                    .onChange(of: selectedDeviceName) { newValue in
                        // Для внутренней модели настроек тоже поддерживаем актуальность
                        viewModel.selectDevice(newValue)
                    }
                }
                .padding(.horizontal)

                Spacer(minLength: 20)
            }
            .padding(.bottom)
        }
        .preferredColorScheme(themeViewModel.currentTheme)
        // Синхронизация при старте
        .onAppear {
            // подтягиваем сохранённые настройки уведомлений
            let enabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
            viewModel.settings.notificationsEnabled = enabled

            // синхронизируем системный статус и расписание
            NotificationManager.authorizationStatus { status in
                let allowed = (status == .authorized || status == .provisional || status == .ephemeral)
                if allowed && enabled {
                    NotificationManager.sync(enabled: true) // перепланируем на всякий случай
                }
            }

            // синхронизируем выбранную модель в Settings с @AppStorage
            viewModel.selectDevice(selectedDeviceName)
        }
        // Возврат из Настроек iOS → обновляемся
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            NotificationManager.authorizationStatus { status in
                let allowed = (status == .authorized || status == .provisional || status == .ephemeral)
                let wants = viewModel.settings.notificationsEnabled
                NotificationManager.sync(enabled: allowed && wants)
            }
        }
        // Алерт при запрете уведомлений
        .alert("Уведомления отключены", isPresented: $showNotificationsDeniedAlert) {
            Button("Открыть настройки") { NotificationManager.openAppSettings() }
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

