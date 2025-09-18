using BusinessView.Api.Models;
using BusinessView.Common;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class TimesheetApiController : ApiController
    {
        private readonly ITimesheetService _timesheetService;
        public TimesheetApiController()
        {
            _timesheetService = new TimesheetService();
        }
        [HttpPost]
        public string AddOrUpdateTimesheetDetails(FeedTimeSheet model)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add User", "Users Api"));
            if (model.IsAbsent == false)
            {
                ModelState.Remove("model.LeaveTypeId");
                ModelState.Remove("model.LeaveSessionId");
            }
            if (ModelState.IsValid)
            {
                int id = Convert.ToInt16(model.FullName);
                if (id > 0)
                {
                    model.Id = id;
                    var loggedUserId = User.Identity.GetUserId<int>();
                    model.loggedUserId = loggedUserId;
                    var result = _timesheetService.AddOrUpdateTimesheetDetails(model);
                    var result1 = new BusinessViewJsonResult
                    {
                        Success = true,
                        Result = result
                    };

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Timesheet details", "timesheet Api"));

                    return JsonConvert.SerializeObject(result1);
                }
            }
            var result2 = new BusinessViewJsonResult
            {
                Success = false,
                ModelState = ModelState
            };

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Timesheet details", "timesheet Api"));

            return JsonConvert.SerializeObject(result2);
        }

        public string GetHistoryDetails(int id)
        {
            var historyDetails = _timesheetService.GetHistoryDetails(id);
            return JsonConvert.SerializeObject(historyDetails);
        }

        [HttpGet]
        public string TimesheetDetailsForIndividualUser(int value)
        {
            try
            {
                var loggedUserId = User.Identity.GetUserId<int>();
                DateTime currentDate = DateTime.Now.Date;

                var timesheetDetails = _timesheetService.GetTimesheetVlauesForButtonDisable(loggedUserId, currentDate);
                if (timesheetDetails == null)
                {
                    var previousDayTimesheetDetails =
                        _timesheetService.GetPreviousDayTimesheetVlauesForButtonDisable(loggedUserId);
                    if (previousDayTimesheetDetails != null && previousDayTimesheetDetails.IsAbsent == false)
                    {
                        if (previousDayTimesheetDetails.OutTime == null)
                        {
                            currentDate = _timesheetService.PreviousMaxDateInTimesheet(loggedUserId);
                        }
                    }
                }

                if (value == 5 || value == 6)
                {
                    var breakDetails = _timesheetService.GetIndividualBreakTimings(loggedUserId, currentDate, value);
                    if (value == 5)
                    {
                        return _timesheetService.GetTimeInHoursandMinutes(breakDetails.BreakIn, loggedUserId);
                    }
                    if (value == 6)
                    {
                        return _timesheetService.GetTimeInHoursandMinutes(breakDetails.BreakOut, loggedUserId);
                    }
                }
                else
                {
                    var details = _timesheetService.AddTimesheetDetailsByIndividualUser(loggedUserId, currentDate, value);
                    if (value == 1)
                    {
                        return _timesheetService.GetTimeInHoursandMinutes(details.InTime, loggedUserId);
                    }
                    if (value == 2)
                    {
                        return _timesheetService.GetTimeInHoursandMinutes(details.LunchBreakStartTime, loggedUserId);
                    }
                    if (value == 3)
                    {
                        return _timesheetService.GetTimeInHoursandMinutes(details.LunchBreakEndTime, loggedUserId);
                    }
                    if (value == 4)
                    {
                        return _timesheetService.GetTimeInHoursandMinutes(details.OutTime, loggedUserId);
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(ex);
                throw;
            }
        }

        public string GetTimesheetDetails()
        {
            var loggedUserId = User.Identity.GetUserId<int>();
            //DateTime currentDate = DateTime.Now.Date;
            var timesheetDetails = _timesheetService.GetTimesheetVlaues(loggedUserId);
            return JsonConvert.SerializeObject(timesheetDetails);
        }

        public List<ViewUserDetails> Get(int userId, DateTime? dateFromValue, DateTime? dateToValue)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Timesheet Records", "Timesheet Api"));

            List<ViewUserDetails> timesheetList;

            try
            {
                if (dateFromValue == null && dateToValue == null)
                {
                    dateFromValue = DateTime.Now.AddDays(-60); 
                    dateToValue = DateTime.Now.Date;
                }
                timesheetList = _timesheetService.IndUserTimesheetDetails(userId, dateFromValue, dateToValue);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Timesheet Records", "Timesheet Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Timesheet Records", "Timesheet Api"));

            return timesheetList;
        }

    }
}

