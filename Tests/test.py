#!/usr/bin/python3
import ubus
import os

# ubus methods info
test_ubus_objects = [
    {
        'uobj': 'input',
        'umethods': [
            {
                'umethod': 'validate',
                'inparams': {"value":"wrong value","lang":"en","datatype":"oid"},
                'outparams': {
                    'datatype': ["__contains__", []]
                }
            },
        ]
    },
]

try:
    ubus.connect()
except:
    print("Can't connect to ubus")

def test_ubus_methods_existance():
    ret = False

    try:
        test_uobj_list = [x['uobj'] for x in test_ubus_objects]
        test_uobj_list.sort()
        uobj_list = []
        for l in list(ubus.objects().keys()):
            if l in test_uobj_list:
                uobj_list.append(l)
        uobj_list.sort()
        assert test_uobj_list == uobj_list
    except:
        assert ret

def test_ubus_api():
    ret = False

    try:
        test_uobjs = [x for x in test_ubus_objects]
        for uobj in test_uobjs:
            test_uobj_methods = [x for x in uobj['umethods']]
            for method in test_uobj_methods:
                res = ubus.call(uobj['uobj'], method['umethod'], method['inparams'])
                assert type(method['outparams']) == type(res[0])
                if isinstance(method['outparams'], dict):
                    for key in method['outparams']:
                        assert key in res[0]
                        if key in res[0]:
                            if len(method['outparams'][key][1]) > 0:
                                assert getattr(method['outparams'][key][1], method['outparams'][key][0])(res[0][key])
    except:
        assert ret
