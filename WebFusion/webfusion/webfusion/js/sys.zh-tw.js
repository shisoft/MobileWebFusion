setInterval(function() {
            $(".dynamicDate").each(function() {
                                   var timestamp = $(this).attr("data-time");
                                   //alert(timestamp);
                                   $(this).html(prettyDate(Number(timestamp)));
                                   });
            }, 1000);

/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */

var dateFormat = function() {
    var token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
    timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
    timezoneClip = /[^-+\dA-Z]/g,
    pad = function(val, len) {
        val = String(val);
        len = len || 2;
        while (val.length < len)
            val = "0" + val;
        return val;
    };
    
    // Regexes and supporting functions are cached through closure
    return function(date, mask, utc) {
        var dF = dateFormat;
        
        // You can't provide utc if you skip other args (use the "UTC:" mask prefix)
        if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
            mask = date;
            date = undefined;
        }
        
        // Passing date through Date applies Date.parse, if necessary
        date = date ? new Date(date) : new Date;
        if (isNaN(date))
            throw SyntaxError("invalid date");
        
        mask = String(dF.masks[mask] || mask || dF.masks["default"]);
        
        // Allow setting the utc argument via the mask
        if (mask.slice(0, 4) == "UTC:") {
            mask = mask.slice(4);
            utc = true;
        }
        
        var _ = utc ? "getUTC" : "get",
        d = date[_ + "Date"](),
        D = date[_ + "Day"](),
        m = date[_ + "Month"](),
        y = date[_ + "FullYear"](),
        H = date[_ + "Hours"](),
        M = date[_ + "Minutes"](),
        s = date[_ + "Seconds"](),
        L = date[_ + "Milliseconds"](),
        o = utc ? 0 : date.getTimezoneOffset(),
        flags = {
        d: d,
        dd: pad(d),
        ddd: dF.i18n.dayNames[D],
        dddd: dF.i18n.dayNames[D + 7],
        m: m + 1,
        mm: pad(m + 1),
        mmm: dF.i18n.monthNames[m],
        mmmm: dF.i18n.monthNames[m + 12],
        yy: String(y).slice(2),
        yyyy: y + "年",
        h: H % 12 || 12,
        hh: pad(H % 12 || 12),
        H: H,
        HH: pad(H),
        M: M,
        MM: pad(M),
        s: s,
        ss: pad(s),
        l: pad(L, 3),
        L: pad(L > 99 ? Math.round(L / 10) : L),
        t: H < 12 ? "a" : "p",
        tt: H < 12 ? "am" : "pm",
        T: H < 12 ? "A" : "P",
        TT: H < 12 ? "上午" : "下午",
        Z: utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
        o: (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
        S: "日"//["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
        };
        
        return mask.replace(token, function($0) {
                            return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
                            });
    };
}();

// Some common format strings
dateFormat.masks = {
    "default": "ddd mmm dd yyyy HH:MM:ss",
shortDate: "m/d/yy",
mediumDate: "mmm d, yyyy",
longDate: "mmmm d, yyyy",
fullDate: "dddd, mmmm d, yyyy",
shortTime: "h:MM TT",
mediumTime: "h:MM:ss TT",
longTime: "h:MM:ss TT Z",
isoDate: "yyyy-mm-dd",
isoTime: "HH:MM:ss",
isoDateTime: "yyyy-mm-dd'T'HH:MM:ss",
isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
dayNames: [
           "周日", "周一", "周二", "周三", "周四", "周五", "周六",
           "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六",
           ],
monthNames: [
             "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月",
             "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"
             ]
};

// For convenience...
Date.prototype.format = function(mask, utc) {
    return dateFormat(this, mask, utc);
};

function prettyDate(time) {
    var time_formats = [
                        [60, '秒', 1], // 60
                        [120, '1 分鐘前', '1 分鐘到現在'], // 60*2
                        [3600, '分鐘', 60], // 60*60, 60
                        [7200, '1 小時前', '1 hour 到現在'], // 60*60*2
                        [86400, '小時', 3600], // 60*60*24, 60*60
                        [172800, '昨天', '明天'], // 60*60*24*2
                        [604800, '天', 86400], // 60*60*24*7, 60*60*24
                        [1209600, '1 個星期', '1 個星期'], // 60*60*24*7*4*2
                        [2419200, '週', 604800], // 60*60*24*7*4, 60*60*24*7
                        [4838400, '1 個月', '1 個月'], // 60*60*24*7*4*2
                        [29030400, '個月', 2419200], // 60*60*24*7*4*12, 60*60*24*7*4
                        [58060800, '1 年', '1 年'], // 60*60*24*7*4*12*2
                        [2903040000, '年', 29030400], // 60*60*24*7*4*12*100, 60*60*24*7*4*12
                        [5806080000, '1 個世紀', '1 個世紀'], // 60*60*24*7*4*12*100*2
                        [58060800000, '世紀', 2903040000] // 60*60*24*7*4*12*100*20, 60*60*24*7*4*12*100
                        ];
    var seconds = (new Date - new Date(time)) / 1000;
    var token = '前', list_choice = 1;
    if (seconds < 0) {
        seconds = Math.abs(seconds);
        token = '到现在';
        list_choice = 2;
    }
    var i = 0, format;
    while (format = time_formats[i++])
        if (seconds < format[0]) {
            if (typeof format[2] == 'string')
                return format[list_choice];
            else
                return Math.floor(seconds / format[2]) + ' ' + format[1] + token;
        }
    return time;
}
;

function ToDate(l) {
    return ToDate2(l.time);
}

function ToDate2(l) {
    //return dateFormat(l.time, "default");
    if (l == null) {
        return "<span>" + 从未 + "</span>";
    }
    var date = new Date(l);
    var details = dateFormat(date, "yyyy mmmm dS ，dddd，TT h:MM:ss");
    var friendly = prettyDate(l);
    return "<span class='dynamicDate' data-val='" + l + "' title='" + details + "'>" + friendly + "</span>";
}