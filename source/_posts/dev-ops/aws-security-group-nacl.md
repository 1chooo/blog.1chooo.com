---
title: "AWS: Comparing Inbound Rules: AWS Security Group vs. Network Access Control List (NACL)"
categories: DevOps
date: 2024-03-22 00:00:00
tags: 
- Cli
- AWS
- EC2
- Security Group
- NACL
cover: /images/cover/dev-ops/aws-security-group-nacl.png
---


During a meeting, we explored a scenario: "If we disable the inbound rule of the Network Access Control List (NACL), the connection will be interrupted. However, if we turn off inbound traffic in the Security Group, would we still be able to connect?" Surprisingly, the answer is YES. The rationale behind this phenomenon will be elaborated on in this article.

We can discuss the differences between Security Group and Network Access Control List (NACL) from various perspectives. The primary difference between the two is:

> The Security Group acts as the firewall for EC2 Instances. 
> 
> The Network ACL serves as the firewall for the VPC Subnets.

![Awesome Cloud — Security Groups and Network ACLs](/images/post/dev-ops/aws-security-group-nacl/arch.png)



Next, we can discuss the differences between the two from the following perspectives:

### Defense Layers

Security Groups are associated with specific instances, which could be an EC2 instance, an ECS cluster, or an RDS database instance. On the other hand, Network Access Control Lists (NACLs) operate at the subnet level. This means that any instance within a subnet that has an associated NACL will automatically adhere to the NACL's rules.

### Application Scope

While Security Groups are tailored for individual instances, NACLs are designed to provide rules for the entire Subnet within a Virtual Private Cloud (VPC).


### Statefulness

Security Group is stateful which means if you allow the inbound traffic, the response traffic is allowed automatically. No matter what the outbound rules are. However, NACL is stateless and do not track the state of a connection.

### Default Rules

By default, Security Groups block all inbound traffic while allowing all outbound traffic. Conversely, Network Access Control Lists (NACLs) have a default rule at the subnet boundary that permits both inbound and outbound traffic. The application of these rules in NACLs is determined by Rule Numbers, with higher numbers indicating higher priority.

### Rule Application Order

NACLs apply a numbered list of rules sequentially. However, Security Groups do not follow a specific order in rule application.

### Traffic Blocking Capabilities

NACLs have the ability to block traffic at the subnet level. In contrast, Security Groups can only block traffic at the instance level.


### Impact on Network Performance

Network Access Control Lists (NACLs) can potentially exert a significant impact on network performance. This is because they operate at the subnet level, applying their rules to all instances within the subnet. On the other hand, Security Groups operate at the instance level, applying their rules only to individual instances, thus having a more localized impact.


### Conclusion
To sum up, let's circle back to our main discussion. "If we disable the inbound rule of the Network Access Control List (NACL), the connection will be interrupted. Why is that?" Unlike Security Groups, NACLs are stateless. This means they do not keep track of the connection's state, and each packet of data is treated independently. Therefore, if we disable the inbound rule of a NACL, it will not allow any incoming traffic, effectively breaking the connection.

On the other hand, if we turn off inbound traffic in the Security Group, we can still connect. The absence of inbound rules does not disrupt the connection because the Security Group functions as a stateful firewall. Even with specific inbound traffic blocked, a connection can still be established as it originates from within the EC2 instance, and the returning traffic is allowed.

This concept aligns with the TCP Three-way Handshake (SYN, SYN-ACK, ACK). The connection is initiated by the client, and the server responds to the client's request. Once we create the tunnel between the server and client, the connection is established.

Therefore, after disabling the Inbound Rule of the Security Group, we have a grace period to inform customers or other parties, preventing an immediate disruption of the service connection.

### References
- [NACL vs Security Group](https://www.mygreatlearning.com/aws/tutorials/nacl-vs-security-group)
- [Security groups vs Network ACLs - What is the Difference?](https://www.knowledgehut.com/tutorials/aws/nacl-vs-security-groups)
- [AWS Network Security: NACL vs Security Groups](https://k21academy.com/amazon-web-services/aws-solutions-architect/aws-security-groups-vs-nacl/)
- [AWS Security Group vs NACL – Key Differences](https://digitalcloud.training/aws-security-group-vs-nacl-key-differences/)
- [Meraki vMX & AWS security group](https://community.meraki.com/t5/Security-SD-WAN/Meraki-vMX-amp-AWS-security-group/m-p/222409#:~:text=Having%20no%20inbound%20rules%20does%20not%20cause%20the%20tunnel%20to,instance%20and%20returning%20traffic%20allowed)
- [AWS — Difference between Security Groups and Network Access Control List (NACL)](https://medium.com/awesome-cloud/aws-difference-between-security-groups-and-network-acls-adc632ea29ae)