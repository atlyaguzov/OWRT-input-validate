
local msgstrs = {
	["en"] = {
		["integer"] = "valid integer value",
		["uinteger"] = "positive integer value",
		["float"] = "valid decimal value",
		["ufloat"] = "positive decimal value",
		["ipaddr"] = "valid IP address",
		["ip4addr"] = "valid IPv4 address",
		["ip6addr"] = "valid IPv6 address",
		["ip4prefix"] = "valid IPv4 prefix value (0-32)",
		["ip6prefix"] = "valid IPv6 prefix value (0-128)",
		["cidr"] = "valid IPv4 or IPv6 CIDR",
		["cidr4"] = "valid IPv4 CIDR",
		["cidr6"] = "valid IPv6 CIDR",
		["ipnet4"] = "IPv4 network in address/netmask notation",
		["ipnet6"] = "IPv6 network in address/netmask notation",
		["ip6hostid"] = "valid IPv6 host id",
		["ipmask"] = "valid network in address/netmask notation",
		["ipmask4"] = "valid IPv4 network",
		["ipmask6"] = "valid IPv6 network",
		["port"] = "valid port value",
		["portrange"] = "valid port or port range (port1-port2)",
		["macaddr"] = "valid multicast MAC address",
		["host"] = "valid hostname or IP address",
		["hostname"] = "valid hostname",
		["network"] = "valid UCI identifier, hostname or IP address range",
		["hostport"] = "valid host:port",
		["ip4addrport"] = "valid IPv4 address:port",
		["ipaddrport"] = "valid address:port",
		["wpakey"] = "valid hexadecimal WPA key",
		["wepkey"] = "valid hexadecimal WEP key",
		["uciname"] = "valid UCI identifier",
		["range"] = "value between %f and %f",
		["min"] = "value greater or equal to %f",
		["max"] = "value smaller or equal to %f",
		["length"] = "value with %d characters",
		["rangelength"] = "value between %d and %d characters",
		["minlength"] = "value with at least %d characters",
		["maxlength"] = "value with at most %d characters",
		["or"] = "One of the following: %s",
		["neg"] = "Potential negation of: %s",
		["phonedigit"] = "valid phone digit (0-9, *, #, ! or .)",
		["timehhmmss"] = "valid time (HH:MM:SS)",
		["dateyyyymmdd"] = "valid date (YYYY-MM-DD)",
		["unique"] = "unique value",
		["hexstring"] = "hexadecimal encoded value",
		["oid"] = "valid SNMP OID",
		["wrong_datatype"] = "wrong datatype",
		["wrong_format"] = "wrong value format",
		["wrong_request"] = "wrong request"
	},
	['ru'] = {
		["integer"] = "верное целое число",
		["uinteger"] = "положительное целое число",
		["float"] = "верное десятичное число",
		["ufloat"] = "положительное десятичное число",
		["ipaddr"] = "верный IP-адрес",
		["ip4addr"] = "верный IPv4 адрес",
		["ip6addr"] = "верный IPv6 адрес",
		["ip4prefix"] = "верное значение IPv4 префикса (0-32)",
		["ip6prefix"] = "верное значение IPv6 префикса (0-128)",
		["cidr"] = "верная IPv4 или IPv6 CIDR",
		["cidr4"] = "верная IPv4 CIDR",
		["cidr6"] = "верная IPv6 CIDR",
		["ipnet4"] = "Сеть IPv4 в формате адрес/маска подсети",
		["ipnet6"] = "Сеть IPv6 в формате адрес/маска подсети",
		["ip6hostid"] = "верный IPv6 идентификатор хоста",
		["ipmask"] = "верная сеть в формате адрес/маска подсети",
		["ipmask4"] = "верная IPv4 сеть",
		["ipmask6"] = "верная IPv6 ctnm",
		["port"] = "верное значение порта",
		["portrange"] = "верный порт или диапазон портов (порт1-порт2)",
		["macaddr"] = "верный мультикаст MAC-адрес",
		["host"] = "верное имя хоста или IP-адрес",
		["hostname"] = "верное имя хоста",
		["network"] = "верный UCI идентификатор, имя хоста или IP-адрес",
		["hostport"] = "верное имя хоста:порт",
		["ip4addrport"] = "верный IPv4 адрес:порт",
		["ipaddrport"] = "верный адрес:порт",
		["wpakey"] = "верное шестнадцатеричное значение WPA ключа",
		["wepkey"] = "верное шестнадцатеричное значение WEP ключа",
		["uciname"] = "верный UCI идентификатор",
		["range"] = "значение в диапазоне от %f до %f",
		["min"] = "значение больше или равное %f",
		["max"] = "значение меньше или равное %f",
		["length"] = "значение с %d символами",
		["rangelength"] = "значение длиной от %d до %d символов",
		["minlength"] = "значение длиной %d или менее символов",
		["maxlength"] = "значение длиной %d или более символов",
		["or"] = "Одно из: %s",
		["neg"] = "Потенциальное отрицание: %s",
		["phonedigit"] = "верный символ номера телефона (0-9, *, #, ! or .)",
		["timehhmmss"] = "верное время (ЧЧ:ММ:СС)",
		["dateyyyymmdd"] = "верная дата (ГГГГ-ММ-ДД)",
		["unique"] = "уникальное значение",
		["hexstring"] = "значение в шестнадцатеричном представлении",
		["oid"] = "верный SNMP OID",
		["wrong_datatype"] = "неверный тип данных",
		["wrong_format"] = "неверный формат значения",
		["wrong_request"] = "неверный запрос"
	}
}

local messages = {}

function messages.translate(lang, datatype)
	return msgstrs[lang][datatype]
end

return messages