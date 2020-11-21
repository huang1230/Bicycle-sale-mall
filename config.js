//将 mysql 数据库的配置单独配置，以达到解耦合的效果，容易维护。
const path = require('path')

module.exports = {
    //数据库信息
    DB_HOST: 'localhost',
    DB_PROT: 3306,
    DB_USER: 'root',
    DB_PASS: '123456',
    DB_NAME: 'car_project',

    //给定注册管理员的权限ID
    ADMIN_OF_REG_ID: 1111,

    //加密的后缀
    ADMINS_MD5: '_huang',
    //服务端口号
    PORT: 3000,
    //本机服务端口域名地址
    HTTP_ROOT: 'http://localhost:3000',

    //文件上传的路径。
    UPLOAD_DIR: path.resolve(__dirname, './public/upload'),

    //邮件代收发SMTP服务器主机地址、端口、授权用户、授权码
    SMTP: {
        QQ : {
            host: 'smtp.qq.com',
            port: 465,
            auth: {
                user: '1046129660@qq.com',
                pass: 'onswkaecuymfbchh'
            }
        },
        SINA : {
            host: 'smtp.sina.cn',
            port: 465,
            auth: {
                user: '17674123978@sina.cn',
                pass: '38a6b29e7842b9b1'
            }
        }
    },

    //短信验证接口AccessKeyId，SecretAccessKey
    SMS : {
        AccessKeyId : 'LTAI4FfBw17jJsZGqNsyxTUa',
        SecretAccessKey : 'M6Mo3bIhkQIqESHocwEf3urS3Bqcee',
        SignName : '自行车销售商城', /* 短信签名-可在短信控制台中找到 */
        TemplateCode : {
            RegisterTemplate : 'SMS_182674875',
            PhoneTemplate : 'SMS_182676788', //更换手机号专用模板
            BothTemplate : 'SMS_182671133' //通用模板
        }, /*短信模板-可在短信控制台中找到，发送国际/港澳台消息时，请使用国际/港澳台短信模版*/
        TemplateParam : function getParam(html) { /*可选:模板中的变量替换JSON串,如模板内容为"亲爱的${name},您的验证码为${code}"时。*/
            return `{"code":${html}}`
        } 
    }
}