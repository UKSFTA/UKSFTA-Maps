class CfgPatches {
    class uksfta_impact {
        name = "UKSFTA Impact";
        author = "UKSF Taskforce Alpha Team";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {"uksfta_main", "uksfta_environment"};
    };
};

class CfgFunctions {
    class uksfta_impact {
        tag = "uksfta_impact";
        class functions {
            file = "z\uksfta\addons\impact\functions";
            class handleHit {};
        };
    };
};

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class EventHandlers {
            class UKSFTA_Impact_Handler {
                handleDamage = "_this call uksfta_impact_fnc_handleHit; _this select 2";
            };
        };
    };
};
