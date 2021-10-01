** Step by Step to create a Virtual Machine
1. home > virtual machines
2. select subscriptions
3. azure spotlight: no
4. name, region, select OS image, size, username, password, confirm password
5. public inbound ports: allow selected ports?
6. inbound ports: RDP 3389?

7. disks: HDD or SDD?
8. virtual network: what is the default? or custom vnet?
9. subnet: new (default) 10.0.1.0/24?
10. NIC: basic or advanced?
11. inbound ports: allow selected ports?
12. inbound ports: RDP 3389?
13. accelerated networking: off?

14. boot diagnostics: on
15. os guest diagnostics: off
16. storage account
17. identity: managed: off
18. auto-shutdown: on or off?
19. backup: on or off?

20. tags?

Last Step: Review and Create

********************* TODO **************************
** Current VM requirments for web servers
********************* TODO **************************



********************* TODO **************************
** Current Server Statistics
** Requests Per Second, Data Inbound/Outbound, Avg CPU Utilization, Avg RAM Utilization
********************* TODO **************************



** Pricing

Resource Groups: no cost

Virtual Network
	Within same region
		inbound		$.01/GB
		outbound	$.01/GB

Virtual Machines (3 year reserved payment plans)
	Dv3		2 CPUs	8GBs	$.0369/hr	$26.57/mo
	Ev3		2 CPUs	16GBs	$.0481/hr	$34.63/mo
	B Series (burstable)


App Services:	
	Standard	$.095/hr	$69/mo	50GB disk
	Premium		$.111/hr	$80/mo	250GB disk
	Isolated	$.38/hr		$274/mo	1TB	disk
	
	Unlimited Apps

** Questions for Team

1. Has it been estimated how much the web servers and VMs will cost to run in Azure?
2. Has Azure LAAS Cost Estimator been run on-premise against our current machines?
3. Has 



