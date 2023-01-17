## Terraform快速搭建HCIE实验1

### 背景

- 快速搭建HCIE实验1
- 只创建资源，不包含应用安装
- VPC之间peering已打通，无需配置
- VPN已打通，无需配置
- 4个VPC跨region互通，无需配置
- DRS源端、目的端已打通，无需配置直接同步
- 无AS资源，AS必须搭配应用安装后的ECS

### 架构

![image-20230117155506945](https://raw.githubusercontent.com/MarcLan/pic/main/image-20230117155506945.png)

### 资源

| Product     | Quantity | description            |
| ----------- | -------- | ---------------------- |
| VPC         | 4        | 每个Region分别两个VPC  |
| VPC Peering | 2        | 连接VPC                |
| Subnet      | 4        | 每个VPC下有一个subnet  |
| SG          | 4        | 每个Region分别两个SG   |
| VPN         | 2        | 打通Region之间连接     |
| ECS         | 4        | 每个VPC下有一个ECS     |
| NAT         | 1        | 关联ECS                |
| RDS         | 2        | 每个Region分别一个实例 |
| DCS         | 1        | 只在主Region           |
| ELB         | 2        | 每个Region一个ELB      |
| DNS         | 1        | 通过域名访问应用       |

### 使用

- 自己测试账号新建有EIP的ECS

- 登录ECS执行，建议用终端软件登录，方便修改配置文件

  ```
  # 登录Terraform终端机
  ssh terraform@43.225.141.64
  密码：Huawei123!
  
  # 进入代码文件目录
  cd /opt/main/
  
  # 修改配置
  vim main.tf
  ```

- 修改配置举例，如果不修改，按默认配置创建的资源会完全对应上面的架构图。如果想修改，参考#注释内容并修改""里的内容

  ```
  ######################################################################
  # Region & AKSK
  ######################################################################
  
  provider "huaweicloud" {
    region     = "ap-southeast-2" # 曼谷region
    access_key = "S9MEZ7ROWLZGLBFXVIBL"  # 填写自己华为云账号的AK
    secret_key = "ngBBuXcB97VAHPJ83vSgM3oWZ1ubyY1Rh8Aqt2GQ" # 填写SK
  }
  
  ######################################################################
  # VPC & Subnet
  ######################################################################
  
  module "vpc" {
    vpc = ({
      # BKK VPC & Subnet
      vpc_web_active_name = "web_active"      # VPC名
      vpc_web_active_cidr = "192.168.0.0/16"  # VPC CIDR
      subnet_web_name     = "subnet_web"      # subnet名字
      subnet_web_cidr     = "192.168.0.0/24"  # subnet cidr
  
      vpc_db_active_name = "db_active"
      vpc_db_active_cidr = "172.16.0.0/12"
      subnet_db_name     = "subnet_db"
      subnet_db_cidr     = "172.16.0.0/24"
  
      vpc_drill_active_name = "drill_active"
      vpc_drill_active_cidr = "10.0.0.0/8"
      subnet_drill_name     = "subnet_drill"
      subnet_drill_cidr     = "10.0.0.0/24"
  
      # HK VPC & Subnet
      vpc_web_branch_name    = "web_branch"
      vpc_web_branch_cidr    = "192.168.0.0/16"
      subnet_web_branch_name = "web_branch"
      subnet_web_branch_cidr = "192.168.1.0/24"
  
      vpc_db_dr_name    = "db_dr"
      vpc_db_dr_cidr    = "172.16.0.0/12"
      subnet_db_dr_name = "db_dr"
      subnet_db_dr_cidr = "172.16.1.0/24"
    })
    source = "../vpc/"
  }
  ```

- 查看即将创建的资源

  ```
  cd /opt/main
  terraform plan
  ```

- 创建资源，全部创建完约10min，RDS，DRS比较耗时

  ```
  terraform apply
  输入yes回车
  ```

  

### Git

- 代码存储在Github个人仓库，下载地址：https://github.com/MarcLan/HCIE-lab1

- Git直接下载

  ```
  git clone https://github.com/MarcLan/HCIE-lab1.git
  ```



