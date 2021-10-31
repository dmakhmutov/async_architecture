* Actor - Account
* Command - Sign in to Tasks Auth
* Data - Account id + Account role
* Event - `account.sign_in`

---

* Actor - Account
* Command - Sign in to Dashboard Auth
* Data - Account id + Account role
* Event - `account.sign_in`

---

* Actor - Account
* Command - Create new task
* Data - Task + Accound id
* Event - `task.created`

---

* Actor - Event `task.created`
* Command - Windrawth money
* Data - Task
* Event - 'balance_log.created'

---

* Actor - Account (admin only)
* Command - Task assign shuffle
* Data - Tasks
* Event - Multiple `task.assigned`

---

* Actor - Account
* Command - Complete a task
* Data - Task
* Event - `task.completed`

---

* Actor - Event `task.completed`
* Command - Add money on task completion
* Data - Task + Balance
* Event - `balance_log.created`

---

* Actor - Event `balance_log.created`
* Command - Create balance log
* Data - Task + BalanceLog
* Event - `balance.changed`

---

* Actor - Scheduler
* Command - Calculate account balance
* Data - Account id + Account balance
* Event - `balance.calculated`

---

* Actor - Event `balance.calculated`
* Command - Apply balance log
* Data - Account id + Account balance
* Event - `balance.applied`

---

* Actor - Event `balance.applied`
* Command - Send Email
* Data - Account id + Account balance
* Event - `balance.email_sended`

---
