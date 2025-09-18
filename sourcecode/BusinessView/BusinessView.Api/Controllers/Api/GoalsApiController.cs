using System;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Queue;
using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.DAL;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class GoalsApiController : ApiController
    {
        private readonly IUserService _userService;
        private readonly IGoalService _goalService;
        private readonly IAuditService _auditService;
        private readonly IProjectService _projectService;
        private readonly IUserProjectService _userProjectService;
        private readonly IWorkflowService _workflowService;

        public GoalsApiController()
        {
            _userService = new UserService();
            _goalService = new GoalService();
            _auditService = new AuditService();
            _projectService = new ProjectService();
            _userProjectService = new UserProjectService();
            _workflowService = new WorkflowService();
        }

        public List<GoalModel> GetAllGoals(int id)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Goals", "Goals Api"));

            List<GoalModel> goalsList;

            try
            {
                goalsList = _goalService.GetAll(id);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Goals", "Goals Api", ex.InnerException));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Goals", "Goals Api"));

            return goalsList;
        }

        public GoalModel GetGoal(int id)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Goal", "Goals Api"));

            GoalModel goal;

            try
            {
                goal = _goalService.GetGoal(id);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Goal", "Goals Api", ex.InnerException));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Goal", "Goals Api"));

            return goal;
        }

        [HttpPost]
        public string AddGoal(GoalModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Goal", "Goals Api"));

            var loggedUserId = User.Identity.GetUserId<int>();
            var loggedUserName = _userService.GetUserName(loggedUserId);

            DateTime dt;
            string[] formats = { "dd-MM-yyyy" };

            if (DateTime.TryParseExact(model.OnDate, formats,CultureInfo.InvariantCulture,DateTimeStyles.None, out dt))
            {
                model.OnBoardDate = dt;
            }
            else
            {
                model.OnBoardDate = null;
            }

            if(model.BoardTypeId != (int)Enumerators.BoardTypes.Api)
            {
                ModelState.Remove("model.BoardTypeApiId");
            }

            if (ModelState.IsValid)
            {
                if (_goalService.CheckGoalExists(model))
                {
                    ModelState.AddModelError("Goal", "Goal already exists.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Goal", "Goals Api"));

                    return JsonConvert.SerializeObject(result);
                }

                var goalId = _goalService.AddOrUpdate(model);

                if(model.BoardTypeId != (int)Enumerators.BoardTypes.Api)
                {
                    _workflowService.AddOrUpdate(goalId, model.BoardTypeId);
                }

                var userIds = model.UserId?.ToList();

                if (userIds != null && userIds.Any())
                {
                    if (userIds[0] != null)
                    {
                        var selectedUserIds = userIds;

                        foreach (var selectedUserId in selectedUserIds)
                        {
                            var userProject = new UserProjectModel
                            {
                                UserId = Convert.ToInt32(selectedUserId),
                                ProjectId = Convert.ToInt32(model.ProjectId),
                                GoalId = goalId
                            };

                            _userProjectService.AddOrUpdate(userProject);
                        }
                    }
                }

                var goalName = _goalService.GetGoalName(goalId);
                var auditId = 0;
                if (model.ProjectId != null)
                {
                    var projectName = _projectService.GetProjectName((int)model.ProjectId);

                    var auditModel = new AuditModel
                    {
                        UserId = loggedUserId,
                        ProjectId = model.ProjectId,
                        GoalId = goalId,
                        FiledName = "New goal added",
                        Description = "<strong>" + loggedUserName + "</strong>" + " added new goal- " + goalName + " for the project " + projectName,
                        UpdatedDate = DateTime.Now
                    };

                    auditId = _auditService.AddOrUpdate(auditModel);
                }

                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                    Data = goalId
                };
               
                var messageJson = new BusinessViewAddGoalMessageJsonResult
                {
                    GoalId = goalId,
                    AuditId = auditId
                };

                new MessageInsertQueueService().InsertMessageInQueue(JsonConvert.SerializeObject(messageJson));

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Goal", "Goals Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Goal", "Goals Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [HttpPut]
        public string UpdateGoal(GoalModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Goal", "Goals Api"));

            var loggedUserId = User.Identity.GetUserId<int>();
            var loggedUserName = _userService.GetUserName(loggedUserId);

            DateTime dt;
            string[] formats = { "dd-MM-yyyy" };

            if (DateTime.TryParseExact(model.OnDate, formats,CultureInfo.InvariantCulture,DateTimeStyles.None, out dt))
            {
                model.OnBoardDate = dt;
            }
            else
            {
                model.OnBoardDate = null;
            }

            if (model.BoardTypeId != (int)Enumerators.BoardTypes.Api)
            {
                ModelState.Remove("model.BoardTypeApiId");
            }

            if (ModelState.IsValid)
            {
                if (_goalService.CheckGoalExists(model))
                {
                    ModelState.AddModelError("Goal", "Goal already exists.");

                    var result = new BusinessViewJsonResult
                    {
                        Success = false,
                        ModelState = ModelState
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Goal", "Goals Api"));

                    return JsonConvert.SerializeObject(result);
                }

                if (model.Id > 0)
                {
                    model.LoggedUserId = loggedUserId;
                    model.LoggedUserName = loggedUserName;
                    var goalId = _goalService.AddOrUpdate(model);                   

                    var projectId = model.ProjectId;

                    _userProjectService.UpdateProjectGoal(goalId);

                    var userIds = model.UserId?.ToList();

                    UpdateGoalMembers(userIds, goalId, projectId);
                }

                var result1 = new BusinessViewJsonResult
                {
                    Success = true,
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Goal", "Goals Api"));

                return JsonConvert.SerializeObject(result1);
            }

            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Goal", "Goals Api"));

            return JsonConvert.SerializeObject(result2);
        }

        [HttpPut]
        public string UpdateGoalMembersInDashboard(GoalModel model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Goal Members In Dashboard", "Goals Api"));

            if (model.Id > 0)
            {
                var goalId = model.Id;
                var projectId = model.ProjectId;

                _userProjectService.UpdateProjectGoal(goalId);

                var userIds = model.UserId?.ToList();

                UpdateGoalMembers(userIds, goalId, projectId);
            }

            var result1 = new BusinessViewJsonResult
            {
                Success = true,
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Goal Members In Dashboard", "Goals Api"));

            return JsonConvert.SerializeObject(result1);
        }

        private void UpdateGoalMembers(List<string> userIds, int goalId, int? ProjectId)
        {
            if (userIds != null && userIds.Any())
            {
                if (userIds[0] != null)
                {
                    var selectedUserIds = userIds;

                    foreach (var selectedUserId in selectedUserIds)
                    {
                        var userProject = new UserProjectModel
                        {
                            UserId = Convert.ToInt32(selectedUserId),
                            ProjectId = Convert.ToInt32(ProjectId),
                            GoalId = goalId
                        };

                        _userProjectService.AddOrUpdate(userProject);
                    }
                }
            }
        }

        [HttpPut]
        public string ArchiveOrUnArchiveGoal(int archiveGoalId, bool isGoalArchive)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Archive Or UnArchive Goal", "Goals Api"));

            try
            {
                var loggedUserId = User.Identity.GetUserId<int>();
                var loggedUserName = _userService.GetUserName(loggedUserId);

                if (archiveGoalId > 0)
                {
                    var model = new GoalModel
                    {
                        LoggedUserId = loggedUserId,
                        LoggedUserName = loggedUserName,
                        Id = archiveGoalId,
                        IsArchived = isGoalArchive,
                        ArchivedDate = DateTime.Now
                    };

                    _goalService.ArchiveOrUnArchiveGoal(model);
                }

                var result = new BusinessViewJsonResult
                {
                    Success = true
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Archive Or UnArchive Goal", "Goals Api"));

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Archive Or UnArchive Goal", "Goals Api", ex.Message));

                throw;
            }
        }

        public void LockGoal(GoalModel model)
        {
            var userId = User.Identity.GetUserId<int>();
            model.LoggedUserId = userId;
            _goalService.LockGoal(model);
        }

        [HttpPost]
        public void UnLockGoal(GoalModel model)
        {
            var userId = User.Identity.GetUserId<int>();
            model.LoggedUserId = userId;
            _goalService.UnLockGoal(model);
        }

        [HttpPut]
        public string ApproveGoal(int goalId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Goal Is Approved", "Goals Api"));

            using (var entities = new BViewEntities())
            {
                try
                {
                    var loggedUserId = User.Identity.GetUserId<int>();
                    var loggedUserName = _userService.GetUserName(loggedUserId);
                    var boardTypeId = entities.Goals.FirstOrDefault(x => x.Id == goalId);

                    if (goalId > 0)
                    {
                        var model = new GoalModel
                        {
                            LoggedUserId = loggedUserId,
                            LoggedUserName = loggedUserName,
                            Id = goalId,
                            IsApproved = true,
                            ApprovedDate = DateTime.Now,
                            BoardType = boardTypeId?.BoardTypeId
                        };

                        _goalService.ApproveGoal(model);
                    }

                    var result = new BusinessViewJsonResult
                    {
                        Success = true,
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Goal Is Approved", "Goals Api"));

                    return JsonConvert.SerializeObject(result);
                }
                catch (Exception ex)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Archive Or UnArchive Goal", "Goals Api", ex.Message));

                    throw;
                }
            }
        }

        public List<GoalMembersModel> GetGoalMembers(int goalId, int projectId)
        {
            using (var entities = new BViewEntities())
            {
                return entities.USP_GetGoalMembers(projectId, goalId).Select(x => new GoalMembersModel
                {
                    ProjectId = projectId,
                    GoalId = goalId,
                    UserId = x.UserId,
                    UserName = x.UserName,
                    UserProfileImage = x.UserProfileImage
                }).ToList();
            }
        }

        [HttpGet]
        public int GetDashboardMembersCount(int userId, int goalId)
        {
            using (var entities = new BViewEntities())
            {
                var count = entities.USP_GetDashboardMembers(userId, goalId).Where(x => x.IsGrp == true || x.IsOwner == true || x.IsDependency == true).ToList().Count;
                return count;
            }
        }

        //public async Task<GoalViewModel> GetGoalDetails(int goalId)
        //{
        //    try
        //    {
        //        var goalDetails = await ApiWrapper.GetResultsFromApiWithAuthorizationUsingGet<GoalViewModel>(string.Format(BusinessViewApiUrls.GetGoalDetailsUrl, goalId));

        //        return goalDetails;
        //    }
        //    catch (Exception ex)
        //    {
        //        LoggingManager.Error(ex);
        //        throw;
        //    }
        //}

        //[HttpGet]
        //[Authorize]
        //public GoalViewModel GetGoalDetailsModel(int jobId)
        //{
        //    try
        //    {
        //        using (var entities = new BViewEntities())
        //        {
        //            var model = new GoalViewModel();
        //            return model;
        //        }
        //    }
        //    catch (Exception e)
        //    {
        //        LoggingManager.Error(e);
        //        throw;
        //    }
        //}
    }
}
