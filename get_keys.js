//为 Cookie 签名值 添加规范字符串，
const fs = require('fs')

let KEY_LEN = 1024 //单个 Cookie 签名值的最大字符长度
let KEY_COUNT = 2048 //Cookie 签名值个数【生成 2048 个 Cookie 签名值】

let arr = [] //用来存储 Cookie 签名值的数组
let CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,./;[]\|/*-+<>?:"{}`~!@#$%^&*()_+-='
//规定 Cookie 签名值的字符组成

for(let i = 0; i< KEY_COUNT; i++){
    let key = ''
    for(let y = 0;y < KEY_LEN; y++){
        key  += CHARS[Math.floor(Math.random() * CHARS.length)]
    }

    arr.push(key)
}

fs.writeFileSync('.key',arr.join('\n'))

