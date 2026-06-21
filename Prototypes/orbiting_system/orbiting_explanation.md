# Main process
The main variables for the inventory there are:
	- `weapon_inv`
		- A 4-sized array that contains the weapons being posessed
		- The default is a null value
	- `holding_index`
		- What index in `weapon_inv` is being held in the hand
	- `stack_of_free_indexes`
		- Stack of free indexes as said
		- Also used to count how many weapons there is.

The way that positions are updated is different based on if it being held and orbiting

The way that we detect new weapons is if they touch an Area2D child node and then run an `add_weapon` function

The way that they are added is that we check if our inv is full and we're not touching a weapon we already have.
Then, add it and set it to the holding weapon if we currently have any weapons.
Then, we call a function on the weapon to change its appearance to indicate the key to press to switch to it.

In the `_physics_process` , we also detect if an input key is pressed and then call the swap function.
This is merely just updating the `holding_index` which will then cause the positions to update within the loop.
But there should probably be some flag raised to allow an animation to play.

I've also made a `remove_weapon` function the weapon_index that breaks.
There is a check on the for loop checking for `need_detachment` flag.
Then the function runs
It raises a flag on the weapon to signal it is detached (`is_detached`).
Then it is removed from the inv and the index is pushed to free index stack.
Also, the necessary process for the weapon can run.
This should run both in throwing and destruction
This would need to change if we have a boomerang like weapon


# Expansion

The weapon needs a `is_detached` and `needs_detachment` flag
