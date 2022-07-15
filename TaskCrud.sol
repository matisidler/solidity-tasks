//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.6;

contract TaskCrud {
    struct Task {
        uint256 id;
        string name;
        string description;
        bool completed;
    }
    Task[] tasks;
    uint256 nextId; // default value 0, add public to see the value

    event NewTask(uint256 id, string name, string description);
    event TaskDeleted(uint256 id);
    event TaskUpdated(uint256 id, string name, string description);
    event NewTaskStatus(
        uint256 id,
        string name,
        string description,
        bool completed
    );

    //create a task with a name and description
    function createTask(string memory _name, string memory _description)
        public
    {
        tasks.push(Task(nextId, _name, _description, false));
        emit NewTask(nextId, _name, _description);
        nextId++;
    }

    //helper internal function
    function findIndex(uint256 _id) internal view returns (uint256) {
        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                return i;
            }
        }
        revert("Task not found");
    }

    //update a task with a certain id, changing the name and description
    function updateTask(
        uint256 _id,
        string memory _name,
        string memory _description
    ) public {
        uint256 index = findIndex(_id);
        tasks[index].name = _name;
        tasks[index].description = _description;
        emit TaskUpdated(_id, _name, _description);
    }

    //read a task with a certain id
    function readTask(uint256 _id) public view returns (Task memory) {
        uint256 index = findIndex(_id);
        return (tasks[index]);
    }

    //delete a task with a certain id
    function deleteTask(uint256 _id) public {
        uint256 index = findIndex(_id);
        delete tasks[index];
        emit TaskDeleted(_id);
    }

    //mark a task with a certain id as completed
    function completeTask(uint256 _id) public {
        uint256 index = findIndex(_id);
        bool alreadyCompleted = tasks[index].completed;
        //if the task is already completed, this function will set "completed" to false.
        tasks[index].completed = !alreadyCompleted;
        emit NewTaskStatus(
            tasks[index].id,
            tasks[index].name,
            tasks[index].description,
            !alreadyCompleted
        );
    }

    //get all tasks
    function getTasks() public view returns (Task[] memory) {
        return tasks;
    }
}
