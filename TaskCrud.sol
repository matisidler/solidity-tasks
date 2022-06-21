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
    event TaskCompleted(uint256 id, string name, string description);

    function createTask(string memory _name, string memory _description)
        public
    {
        tasks.push(Task(nextId, _name, _description, false));
        emit NewTask(nextId, _name, _description);
        nextId++;
    }

    function findIndex(uint256 _id) internal view returns (uint256) {
        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                return i;
            }
        }
        revert("Task not found");
    }

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

    function readTask(uint256 _id)
        public
        view
        returns (
            uint256,
            string memory,
            string memory
        )
    {
        uint256 index = findIndex(_id);
        return (tasks[index].id, tasks[index].name, tasks[index].description);
    }

    function deleteTask(uint256 _id) public {
        uint256 index = findIndex(_id);
        delete tasks[index];
        emit TaskDeleted(_id);
    }

    function completeTask(uint256 _id) public {
        uint256 index = findIndex(_id);
        bool alreadyCompleted = tasks[index].completed;
        //if the task is already completed, this function will set "completed" to false.
        tasks[index].completed = !alreadyCompleted;
        if (!alreadyCompleted) {
            emit TaskCompleted(
                tasks[index].id,
                tasks[index].name,
                tasks[index].description
            );
        }
    }
}
