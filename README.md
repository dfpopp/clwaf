<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="web/static/images/logo-dark.svg">
  <img src="web/static/images/logo.svg" alt="畅来WAF" width="320">
</picture>

# 畅来WAF

**新一代人机验证与纵深防御引擎**

[官网](https://www.clwaf.com) ｜ [版本对比](https://www.clwaf.com/#compare) ｜ [问题反馈](../../issues)

</div>

---

Go 语言原生的站点纵深防御：人机识别、计算挑战、多形态验证、攻击特征防护、等候室、威胁情报共享，开箱即用，数据全程留在你自己的服务器上。

## 快速开始

```bash
# 1. 下载 Releases 压缩包并解压到 /usr/local/waf

# 2. 编辑 config/database.json，填写 MySQL 地址、账号、密码

# 3. 启动（首次启动自动建库导入 sql/init.sql）
./wafctl.sh start
```

后台地址 `http://服务器IP:后台端口`（见 `config/app.json`），默认账号 `admin / admin123`，登录后请立即改密。

完整部署说明（systemd 自启、升级流程、端口建议）见包内 **《部署说明.txt》**。

## 版本

本仓库发布免费版发行包，与 Pro 版能力对比见[官网](https://www.clwaf.com/#compare)。

## 反馈

[GitHub Issues](../../issues) ｜ [https://www.clwaf.com](https://www.clwaf.com)
