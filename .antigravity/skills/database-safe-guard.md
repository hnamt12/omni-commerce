# 👑 DATABASE SAFE GUARD SKILL (HIGH PRIORITY)

## CRITICAL DIRECTIVE
You are STRICTLY FORBIDDEN from generating, writing, or executing any code that drops, truncates, deletes, or alters database structures destructively. 

## REFACTORING CONSTRAINTS
- The `down()` method in ALL migrations must remain EMPTY or commented out. Never drop tables.
- Data updates must use selective model modification (`$model->update()`), never overwrite table contexts or clear configurations globally.
- Failure to comply with this safety mandate will crash the system. Protect the data at all costs.