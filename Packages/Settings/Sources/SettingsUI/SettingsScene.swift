import Combine
import SettingsStore
import SwiftUI
import VirtualMachineEditorService
import VirtualMachineFleetService
import VirtualMachineSourceNameRepository

public struct SettingsScene: Scene {
    private let settingsStore: SettingsStore
    private let virtualMachinesSourceNameRepository: VirtualMachineSourceNameRepository
    private let isVirtualMachineSettingsEnabled: AnyPublisher<Bool, Never>

    public init(
        settingsStore: SettingsStore,
        sourceNameRepository: VirtualMachineSourceNameRepository,
        fleetService: VirtualMachineFleetService,
        editorService: VirtualMachineEditorService
    ) {
        self.settingsStore = settingsStore
        self.virtualMachinesSourceNameRepository = sourceNameRepository
        self.isVirtualMachineSettingsEnabled = Publishers.CombineLatest(
            fleetService.isStarted,
            editorService.isStarted
        )
        .map { !$0 && !$1 }
        .eraseToAnyPublisher()
    }

    public var body: some Scene {
        Settings {
            SettingsView(
                settingsStore: settingsStore,
                virtualMachinesSourceNameRepository: virtualMachinesSourceNameRepository,
                isVirtualMachineSettingsEnabled: isVirtualMachineSettingsEnabled
            )
        }
    }
}
