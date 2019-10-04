#!/usr/bin/env python
# -*- coding:utf-8 -*- 

################################################################################

import time

def ZabbixTemplateHeader(name, app):
    print """<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
    <version>4.0</version>
    <date>""" + time.strftime("%Y-%m-%dT%H:%M:%SZ") + """</date>
    <groups>
        <group>
            <name>Templates/Modules</name>
        </group>
    </groups>
    <templates>
        <template>
            <template>""" + name + """</template>
            <name>""" + name + """</name>
            <description/>
            <groups>
                <group>
                    <name>Templates/Modules</name>
                </group>
            </groups>
            <applications>
                <application>
                    <name>""" + app + """</name>
                </application>
            </applications>
            <items>"""
    return

def ZabbixTemplateItem(name, oid, app = 'LDPB_ATCA_SNMP_Monitoring', preproc = '', unit = ''):
    item = """                <item>
                    <name>""" + name + """</name>
                    <type>1</type>
                    <snmp_community>public</snmp_community>
                    <snmp_oid>""" + oid + """</snmp_oid>
                    <key>""" + name + """</key>
                    <delay>30s</delay>
                    <history>90d</history>
                    <trends>365d</trends>
                    <status>0</status>
                    <value_type>3</value_type>
                    <allowed_hosts/>
                    <units>""" + unit + """</units>
                    <snmpv3_contextname/>
                    <snmpv3_securityname/>
                    <snmpv3_securitylevel>0</snmpv3_securitylevel>
                    <snmpv3_authprotocol>0</snmpv3_authprotocol>
                    <snmpv3_authpassphrase/>
                    <snmpv3_privprotocol>0</snmpv3_privprotocol>
                    <snmpv3_privpassphrase/>
                    <params/>
                    <ipmi_sensor/>
                    <authtype>0</authtype>
                    <username/>
                    <password/>
                    <publickey/>
                    <privatekey/>
                    <port/>
                    <description/>
                    <inventory_link>0</inventory_link>
                    <applications>
                        <application>
                            <name>""" + app + """</name>
                        </application>
                    </applications>
                    <valuemap/>
                    <logtimefmt/>
                    <preprocessing>
                    """ + preproc + """
                    </preprocessing>
                    <jmx_endpoint/>
                    <timeout>3s</timeout>
                    <url/>
                    <query_fields/>
                    <posts/>
                    <status_codes>200</status_codes>
                    <follow_redirects>1</follow_redirects>
                    <post_type>0</post_type>
                    <http_proxy/>
                    <headers/>
                    <retrieve_mode>0</retrieve_mode>
                    <request_method>0</request_method>
                    <output_format>0</output_format>
                    <allow_traps>0</allow_traps>
                    <ssl_cert_file/>
                    <ssl_key_file/>
                    <ssl_key_password/>
                    <verify_peer>0</verify_peer>
                    <verify_host>0</verify_host>
                    <master_item/>
                </item>"""
    #item = '' + name + " -> " + oid + ' (' +  preproc + ').'
    #item = oid + ' '
    print item
    return

def ZabbixTemplateTrailer():
    print """            </items>
            <discovery_rules/>
            <httptests/>
            <macros/>
            <templates>
                <template>
                    <name>Template Module ICMP Ping</name>
                </template>
            </templates>
            <screens/>
        </template>
    </templates>
</zabbix_export>
"""
    return

################################################################################

CELSIUS='°Celsius'

# Generate all slot's LDPB items
def LdpbSlotsItems():
    SLOTS = { # Physical location starting at 1 for left-most board -> Logical address as decimal integer
        '01': '154',
        '02': '150',
        '03': '146',
        '04': '142',
        '05': '138',
        '06': '134',
        '07': '130',
        '08': '132',
        '09': '136',
        '10': '140',
        '11': '144',
        '12': '148',
        '13': '152',
        '14': '156',
    }
    #for s in SLOTS:
    #    print 'Slot #' + s + ' -> ' + format(int(SLOTS[s]), '02x') + ' -> ' + SLOTS[s]
    
    AMCS = { # Physical location starting at 5 for upper-most board -> Logical address as decimal integer
        # '01': '?',
        # '02': '?',
        # '03': '?',
        # '04': '?',
        '5': '2',
        '6': '18',
        '7': '34',
        '8': '50',
    }
    
    for s in SLOTS:
        slotPrefix = "Slot" + s + "_"
        ZabbixTemplateItem(slotPrefix + 'LArC_FPGA_Temp', '.1.3.6.1.4.1.16394.2.1.1.3.1.28.' + SLOTS[s] + '.71', unit = CELSIUS)
        for a in AMCS:
            amcPrefix = slotPrefix + "AMC" + a + "_"
            oidSuffix = '.' + SLOTS[s] + '.' + AMCS[a]
            ZabbixTemplateItem(amcPrefix + 'FPGA_Temp', '.1.3.6.1.4.1.16394.2.1.1.3.1.28' + oidSuffix, unit = CELSIUS)
            ZabbixTemplateItem(amcPrefix + 'Hotswap_State', '.1.3.6.1.4.1.16394.2.1.1.2.1.11' + '.' + SLOTS[s] + '.' + str(int(a) - 5))
    return

# Generate all shelve's temperature items
def ShelfTemperatureItems():
    TEMPS = { # Desired item name -> corresponding value's SNMP OID
        'Center_Intake_Temp':   '.1.3.6.1.4.1.16394.2.1.1.3.1.28.90.8',
        'Center_Outtake_Temp':  '.1.3.6.1.4.1.16394.2.1.1.3.1.28.92.7',
        'Left_Intake_Temp':     '.1.3.6.1.4.1.16394.2.1.1.3.1.28.90.7',
        'Left_Outtake_Temp':    '.1.3.6.1.4.1.16394.2.1.1.3.1.28.92.6',
        'Right_Intake_Temp':    '.1.3.6.1.4.1.16394.2.1.1.3.1.28.90.9',
        'Right_Outtake_Temp':   '.1.3.6.1.4.1.16394.2.1.1.3.1.28.92.8',
    }
    for t in TEMPS:
        ZabbixTemplateItem(t, TEMPS[t], unit = CELSIUS);
    return

# Generate all shelve's fan items
def ShelfFanItems():
    FANS = { # Desired item name -> corresponding value's SNMP OID
        'Lower_Fantray_Level': '.1.3.6.1.4.1.16394.2.1.1.33.1.19.1',
        'Upper_Fantray_Level': '.1.3.6.1.4.1.16394.2.1.1.33.1.19.2',
    }
    for f in FANS:
        ZabbixTemplateItem(f, FANS[f], preproc = """        <step>
                                <type>5</type>
                                <params>^[0-Z][0-Z]
    \\0</params>
                            </step>
                            <step>
                                <type>8</type>
                                <params/>
                            </step>""");
    return

################################################################################

if __name__ == '__main__':
    ZabbixTemplateHeader('LDPB_ATCA_SNMP', 'LDPB_ATCA_SNMP_Monitoring')
    LdpbSlotsItems()
    ShelfTemperatureItems()
    ShelfFanItems()
    ZabbixTemplateTrailer()
