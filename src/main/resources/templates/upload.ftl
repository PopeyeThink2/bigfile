<html>
<head>
    <meta charset="utf-8">
    <title>分片上传</title>
    <script src="http://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript">
        var hexcase = 0;  /* hex output format. 0 - lowercase; 1 - uppercase        */
        var b64pad  = ""; /* base-64 pad character. "=" for strict RFC compliance   */
        var chrsz   = 8;  /* bits per input character. 8 - ASCII; 16 - Unicode      */

        /*
         * These are the functions you'll usually want to call
         * They take string arguments and return either hex or base-64 encoded strings
         */
        function hex_md5(s){ return binl2hex(core_md5(str2binl(s), s.length * chrsz));}
        function b64_md5(s){ return binl2b64(core_md5(str2binl(s), s.length * chrsz));}
        function str_md5(s){ return binl2str(core_md5(str2binl(s), s.length * chrsz));}
        function hex_hmac_md5(key, data) { return binl2hex(core_hmac_md5(key, data)); }
        function b64_hmac_md5(key, data) { return binl2b64(core_hmac_md5(key, data)); }
        function str_hmac_md5(key, data) { return binl2str(core_hmac_md5(key, data)); }

        /*
         * Perform a simple self-test to see if the VM is working
         */
        function md5_vm_test()
        {
            return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
        }

        /*
         * Calculate the MD5 of an array of little-endian words, and a bit length
         */
        function core_md5(x, len)
        {
            /* append padding */
            x[len >> 5] |= 0x80 << ((len) % 32);
            x[(((len + 64) >>> 9) << 4) + 14] = len;

            var a =  1732584193;
            var b = -271733879;
            var c = -1732584194;
            var d =  271733878;

            for(var i = 0; i < x.length; i += 16)
            {
                var olda = a;
                var oldb = b;
                var oldc = c;
                var oldd = d;

                a = md5_ff(a, b, c, d, x[i+ 0], 7 , -680876936);
                d = md5_ff(d, a, b, c, x[i+ 1], 12, -389564586);
                c = md5_ff(c, d, a, b, x[i+ 2], 17,  606105819);
                b = md5_ff(b, c, d, a, x[i+ 3], 22, -1044525330);
                a = md5_ff(a, b, c, d, x[i+ 4], 7 , -176418897);
                d = md5_ff(d, a, b, c, x[i+ 5], 12,  1200080426);
                c = md5_ff(c, d, a, b, x[i+ 6], 17, -1473231341);
                b = md5_ff(b, c, d, a, x[i+ 7], 22, -45705983);
                a = md5_ff(a, b, c, d, x[i+ 8], 7 ,  1770035416);
                d = md5_ff(d, a, b, c, x[i+ 9], 12, -1958414417);
                c = md5_ff(c, d, a, b, x[i+10], 17, -42063);
                b = md5_ff(b, c, d, a, x[i+11], 22, -1990404162);
                a = md5_ff(a, b, c, d, x[i+12], 7 ,  1804603682);
                d = md5_ff(d, a, b, c, x[i+13], 12, -40341101);
                c = md5_ff(c, d, a, b, x[i+14], 17, -1502002290);
                b = md5_ff(b, c, d, a, x[i+15], 22,  1236535329);

                a = md5_gg(a, b, c, d, x[i+ 1], 5 , -165796510);
                d = md5_gg(d, a, b, c, x[i+ 6], 9 , -1069501632);
                c = md5_gg(c, d, a, b, x[i+11], 14,  643717713);
                b = md5_gg(b, c, d, a, x[i+ 0], 20, -373897302);
                a = md5_gg(a, b, c, d, x[i+ 5], 5 , -701558691);
                d = md5_gg(d, a, b, c, x[i+10], 9 ,  38016083);
                c = md5_gg(c, d, a, b, x[i+15], 14, -660478335);
                b = md5_gg(b, c, d, a, x[i+ 4], 20, -405537848);
                a = md5_gg(a, b, c, d, x[i+ 9], 5 ,  568446438);
                d = md5_gg(d, a, b, c, x[i+14], 9 , -1019803690);
                c = md5_gg(c, d, a, b, x[i+ 3], 14, -187363961);
                b = md5_gg(b, c, d, a, x[i+ 8], 20,  1163531501);
                a = md5_gg(a, b, c, d, x[i+13], 5 , -1444681467);
                d = md5_gg(d, a, b, c, x[i+ 2], 9 , -51403784);
                c = md5_gg(c, d, a, b, x[i+ 7], 14,  1735328473);
                b = md5_gg(b, c, d, a, x[i+12], 20, -1926607734);

                a = md5_hh(a, b, c, d, x[i+ 5], 4 , -378558);
                d = md5_hh(d, a, b, c, x[i+ 8], 11, -2022574463);
                c = md5_hh(c, d, a, b, x[i+11], 16,  1839030562);
                b = md5_hh(b, c, d, a, x[i+14], 23, -35309556);
                a = md5_hh(a, b, c, d, x[i+ 1], 4 , -1530992060);
                d = md5_hh(d, a, b, c, x[i+ 4], 11,  1272893353);
                c = md5_hh(c, d, a, b, x[i+ 7], 16, -155497632);
                b = md5_hh(b, c, d, a, x[i+10], 23, -1094730640);
                a = md5_hh(a, b, c, d, x[i+13], 4 ,  681279174);
                d = md5_hh(d, a, b, c, x[i+ 0], 11, -358537222);
                c = md5_hh(c, d, a, b, x[i+ 3], 16, -722521979);
                b = md5_hh(b, c, d, a, x[i+ 6], 23,  76029189);
                a = md5_hh(a, b, c, d, x[i+ 9], 4 , -640364487);
                d = md5_hh(d, a, b, c, x[i+12], 11, -421815835);
                c = md5_hh(c, d, a, b, x[i+15], 16,  530742520);
                b = md5_hh(b, c, d, a, x[i+ 2], 23, -995338651);

                a = md5_ii(a, b, c, d, x[i+ 0], 6 , -198630844);
                d = md5_ii(d, a, b, c, x[i+ 7], 10,  1126891415);
                c = md5_ii(c, d, a, b, x[i+14], 15, -1416354905);
                b = md5_ii(b, c, d, a, x[i+ 5], 21, -57434055);
                a = md5_ii(a, b, c, d, x[i+12], 6 ,  1700485571);
                d = md5_ii(d, a, b, c, x[i+ 3], 10, -1894986606);
                c = md5_ii(c, d, a, b, x[i+10], 15, -1051523);
                b = md5_ii(b, c, d, a, x[i+ 1], 21, -2054922799);
                a = md5_ii(a, b, c, d, x[i+ 8], 6 ,  1873313359);
                d = md5_ii(d, a, b, c, x[i+15], 10, -30611744);
                c = md5_ii(c, d, a, b, x[i+ 6], 15, -1560198380);
                b = md5_ii(b, c, d, a, x[i+13], 21,  1309151649);
                a = md5_ii(a, b, c, d, x[i+ 4], 6 , -145523070);
                d = md5_ii(d, a, b, c, x[i+11], 10, -1120210379);
                c = md5_ii(c, d, a, b, x[i+ 2], 15,  718787259);
                b = md5_ii(b, c, d, a, x[i+ 9], 21, -343485551);

                a = safe_add(a, olda);
                b = safe_add(b, oldb);
                c = safe_add(c, oldc);
                d = safe_add(d, oldd);
            }
            return Array(a, b, c, d);

        }

        /*
         * These functions implement the four basic operations the algorithm uses.
         */
        function md5_cmn(q, a, b, x, s, t)
        {
            return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s),b);
        }
        function md5_ff(a, b, c, d, x, s, t)
        {
            return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t);
        }
        function md5_gg(a, b, c, d, x, s, t)
        {
            return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t);
        }
        function md5_hh(a, b, c, d, x, s, t)
        {
            return md5_cmn(b ^ c ^ d, a, b, x, s, t);
        }
        function md5_ii(a, b, c, d, x, s, t)
        {
            return md5_cmn(c ^ (b | (~d)), a, b, x, s, t);
        }

        /*
         * Calculate the HMAC-MD5, of a key and some data
         */
        function core_hmac_md5(key, data)
        {
            var bkey = str2binl(key);
            if(bkey.length > 16) bkey = core_md5(bkey, key.length * chrsz);

            var ipad = Array(16), opad = Array(16);
            for(var i = 0; i < 16; i++)
            {
                ipad[i] = bkey[i] ^ 0x36363636;
                opad[i] = bkey[i] ^ 0x5C5C5C5C;
            }

            var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
            return core_md5(opad.concat(hash), 512 + 128);
        }

        /*
         * Add integers, wrapping at 2^32. This uses 16-bit operations internally
         * to work around bugs in some JS interpreters.
         */
        function safe_add(x, y)
        {
            var lsw = (x & 0xFFFF) + (y & 0xFFFF);
            var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
            return (msw << 16) | (lsw & 0xFFFF);
        }

        /*
         * Bitwise rotate a 32-bit number to the left.
         */
        function bit_rol(num, cnt)
        {
            return (num << cnt) | (num >>> (32 - cnt));
        }

        /*
         * Convert a string to an array of little-endian words
         * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
         */
        function str2binl(str)
        {
            var bin = Array();
            var mask = (1 << chrsz) - 1;
            for(var i = 0; i < str.length * chrsz; i += chrsz)
                bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32);
            return bin;
        }

        /*
         * Convert an array of little-endian words to a string
         */
        function binl2str(bin)
        {
            var str = "";
            var mask = (1 << chrsz) - 1;
            for(var i = 0; i < bin.length * 32; i += chrsz)
                str += String.fromCharCode((bin[i>>5] >>> (i % 32)) & mask);
            return str;
        }

        /*
         * Convert an array of little-endian words to a hex string.
         */
        function binl2hex(binarray)
        {
            var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
            var str = "";
            for(var i = 0; i < binarray.length * 4; i++)
            {
                str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) +
                    hex_tab.charAt((binarray[i>>2] >> ((i%4)*8  )) & 0xF);
            }
            return str;
        }

        /*
         * Convert an array of little-endian words to a base-64 string
         */
        function binl2b64(binarray)
        {
            var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            var str = "";
            for(var i = 0; i < binarray.length * 4; i += 3)
            {
                var triplet = (((binarray[i   >> 2] >> 8 * ( i   %4)) & 0xFF) << 16)
                    | (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
                    |  ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF);
                for(var j = 0; j < 4; j++)
                {
                    if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
                    else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
                }
            }
            return str;
        }
    </script>
    <script type="text/javascript">
        var i = -1;
        var shardSize = 1 * 1024 * 1024;    //以1MB为一个分片
        var succeed = 0;
        var dataBegin;  //开始时间
        var dataEnd;    //结束时间
        var action = false;
        var page = {
            init: function () {
                $("#upload").click(function () {
                    dataBegin = new Date();
                    var file = $("#file")[0].files[0];  //文件对象
                    isUpload(file);
                });

            }
        };
        $(function () {
            page.init();
        });

        function isUpload(file) {
            //构造一个表单，FormData是HTML5新增的
            var form = new FormData();
            var r = new FileReader();
            r.readAsBinaryString(file);
            $(r).load(function (e) {
                var blob = e.target.result;
                var md5 = hex_md5(blob);
                form.append("md5", md5);
                //Ajax提交
                $.ajax({
                    url: "file/isUpload",
                    type: "POST",
                    data: form,
                    async: true,        //异步
                    processData: false,  //告诉jquery不要对form进行处理
                    contentType: false,  //指定为false才能形成正确的Content-Type
                    success: function (data) {
                        //alert(data.flag);
                        var uuid = data.fileId;
                        //获取处理返回的map信息
                        if (data.flag == "0") {
                            //没有上传过文件
                            realUpload(file, uuid, md5, data.date);
                        } else if (data.flag == "1") {
                            //已经上传部分
                            realUpload(file, uuid, md5, data.date);
                        } else if (data.flag == "2") {
                            //文件已经上传过
                            alert("文件已经上传过,秒传了！！");
                        }
                    }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器出错!");
                    }
                })
            })
        };

        function realUpload(file, uuid, md5, date) {
            name = file.name;
            size = file.size;
            var shardCount = Math.ceil(size / shardSize);  //总片数
            if (i > shardCount) {
                return;
            } else {
                if (!action) {
                    i += 1;  //只有在检测分片时,i才去加1; 上传文件时无需加1
                }
            }
            //计算每一片的起始与结束位置
            var start = i * shardSize;
            var end = Math.min(size, start + shardSize);
            //构造一个表单，FormData是HTML5新增的
            var form = new FormData();
            if (!action) {
                form.append("action", "check");  //检测分片是否上传
                $("#param").append("<br/>" + "action==check " + "&nbsp;&nbsp;");
            } else {
                form.append("action", "upload");  //直接上传分片
                form.append("data", file.slice(start, end));  //slice方法用于切出文件的一部分
                $("#param").append("<br/>" + "action==upload ");
            }
            form.append("uuid", uuid);
            form.append("md5", md5);
            form.append("date", date);
            form.append("name", name);
            form.append("size", size);
            form.append("total", shardCount);  //总片数
            form.append("index", i + 1);        //当前是第几片

            var index = i + 1;
            $("#param").append("index==" + index);
            //按大小切割文件段　　
            var data = file.slice(start, end);
            var r = new FileReader();
            r.readAsBinaryString(data);
            $(r).load(function (e) {
                var bolb = e.target.result;
                var partMd5 = hex_md5(bolb);
                form.append("partMd5", partMd5);
                //Ajax提交
                $.ajax({
                    url: "file/upload",
                    type: "POST",
                    data: form,
                    async: true,        //异步
                    processData: false,  //很重要，告诉jquery不要对form进行处理
                    contentType: false,  //很重要，指定为false才能形成正确的Content-Type
                    success: function (data) {
                        var fileuuid = data.fileId;
                        var flag = data.flag;
                        if (flag != "2") {
                            //服务器返回该分片是否上传过
                            if (flag == "0") {
                                //未上传,继续上传
                                action = true;
                            } else if (flag == "1") {
                                //已上传
                                action = false;
                                ++succeed;
                                $("#output").text(succeed + " / " + shardCount);
                            }
                            realUpload(file, uuid, md5, date);
                        } else {
                            ++succeed;
                            $("#output").text(succeed + " / " + shardCount);
                            //服务器返回分片是否上传成功
                            if (succeed == shardCount) {
                                dataEnd = new Date();
                                $("#uuid").append(fileuuid);
                                $("#useTime").append((dataEnd.getTime() - dataBegin.getTime()) / 1000);
                                $("#useTime").append("s")
                                $("#param").append("<br/>" + "上传成功！");
                            }
                        }
                    }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("服务器出错!");
                    }
                });
            })
        }
    </script>
</head>

<body>

<input type="file" id="file"/>
<button id="upload">上传</button>
<br/><br/>
<span style="font-size:16px">上传进度：</span><span id="output" style="font-size:16px"></span>
<span id="useTime" style="font-size:16px;margin-left:20px;">上传时间：</span>
<span id="uuid" style="font-size:16px;margin-left:20px;">文件ID：</span>
<br/><br/>
<span id="param" style="font-size:16px">上传过程：</span>

</body>
</html>