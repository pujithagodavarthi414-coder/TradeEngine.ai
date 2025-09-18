using System;
using System.Collections.Generic;
using System.Web.Http;
using BusinessView.Common;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;

namespace BusinessView.Api.Controllers.Api
{
    public class TimesheetHistoryApiController : ApiController
    {
        private readonly IAuditService _auditService;
        private readonly ITimesheetService _timesheetService;

        public TimesheetHistoryApiController()
        {
            _auditService = new AuditService();
            _timesheetService = new TimesheetService();
        }

        public List<AuditModel> Get()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Audit", "Timesheet Api"));

            List<AuditModel> auditList;

            try
            {
                var dateTime = DateTime.Now.Date;
                
                auditList = _timesheetService.GetTimesheetAudit(0, dateTime, dateTime);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Audit", "Timesheet Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Audit", "Timesheet Api"));

            return auditList;
        }

        public List<AuditModel> Get(int userId, DateTime? dateFrom, DateTime? dateTo)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Audit", "Timesheet Api"));

            List<AuditModel> audits;

            try
            {
                if (dateFrom == null && dateTo == null)
                {
                    dateFrom = DateTime.Now.Date;
                    dateTo = DateTime.Now.Date;
                }

                audits = _timesheetService.GetTimesheetAudit(userId, dateFrom, dateTo);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Audit", "Timesheet Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Audit", "Timesheet Api"));

            return audits;
        }
    }
}
