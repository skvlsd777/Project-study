import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel() // Для остальных настроек
    @EnvironmentObject var themeViewModel: ThemeViewModel // Подключаем ThemeViewModel

    var body: some View {
        ZStack {
            // Фон зависит от текущей темы
            themeViewModel.currentTheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Настройки")
                    .font(.largeTitle)
                    .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                    .padding()
                
                // Toggle для темы
                Toggle(isOn: $themeViewModel.isDarkMode) {
                    Text("Темная тема")
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                }
                .padding()
                
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
                                NotificationManager.openAppSettings()
                            }
                        }
                    } else {
                        NotificationManager.cancelDaily()
                    }
                }



                // Picker для модели Apple Watch
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
        // Применяем текущую тему ко всему экрану
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeViewModel()) // Передаем ThemeViewModel
    }
}

