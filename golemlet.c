#include "ets_sys.h"
#include "os_type.h"
#include "driver/uart.h"
#include "osapi.h"
#include "mqtt.h"
#include "debug.h"
#include "gpio.h"
#include "user_interface.h"
#include "mem.h"
#include "espconn.h"

#define user_procTaskPrio        0
#define user_procTaskQueueLen    1
os_event_t    user_procTaskQueue[user_procTaskQueueLen];
static void user_procTask(os_event_t *events);
static volatile os_timer_t some_timer;

MQTT_Client mqttClient;

void some_timerfunc(void *arg)
{
    //Do blinky stuff
    if (GPIO_REG_READ(GPIO_OUT_ADDRESS) & BIT2)
    {
        //Set GPIO2 to LOW
        gpio_output_set(0, BIT2, BIT2, 0);
    }
    else
    {
        //Set GPIO2 to HIGH
        gpio_output_set(BIT2, 0, BIT2, 0);
    }
}

//Do nothing function
static void ICACHE_FLASH_ATTR
user_procTask(os_event_t *events)
{
    os_delay_us(10);
}

void ICACHE_FLASH_ATTR print_info()
{
  INFO("\r\n\r\n[INFO] BOOTUP...\r\n");
  INFO("[INFO] SDK: %s\r\n", system_get_sdk_version());
  INFO("[INFO] Chip ID: %08X\r\n", system_get_chip_id());
  INFO("[INFO] Memory info:\r\n");
  system_print_meminfo();

  INFO("[INFO] -------------------------------------------\n");
  INFO("[INFO] Build time: %s\n", BUID_TIME);
  INFO("[INFO] -------------------------------------------\n");

}


static void ICACHE_FLASH_ATTR app_init(void)
{
  MQTT_InitConnection(&mqttClient, MQTT_HOST, MQTT_PORT, DEFAULT_SECURITY);

  if ( !MQTT_InitClient(&mqttClient, MQTT_CLIENT_ID, MQTT_USER, MQTT_PASS, MQTT_KEEPALIVE, MQTT_CLEAN_SESSION) )
  {
    INFO("Failed to initialize properly. Check MQTT version.\r\n");
    return;
  }
  // MQTT_InitLWT(&mqttClient, "/lwt", "offline", 0, 0);
  // MQTT_OnConnected(&mqttClient, mqttConnectedCb);
  // MQTT_OnDisconnected(&mqttClient, mqttDisconnectedCb);
  // MQTT_OnPublished(&mqttClient, mqttPublishedCb);
  // MQTT_OnData(&mqttClient, mqttDataCb);

  // WIFI_Connect(STA_SSID, STA_PASS, wifiConnectCb);
}
void user_init(void)
{
  system_init_done_cb(app_init);
}

