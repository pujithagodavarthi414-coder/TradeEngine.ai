using System;
using System.Collections.Generic;
using System.Web.Http;
using BusinessView.Common;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;

namespace BusinessView.Api.Controllers.Api
{
    public class AuditHistoryApiController : ApiController
    {
        private readonly IAuditService _auditService;

        public AuditHistoryApiController()
        {
            _auditService = new AuditService();
        }

        public List<AuditModel> Get()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Audit", "Audit Api"));

            List<AuditModel> auditList;

            try
            {
                var dateTime = DateTime.Now.Date.ToString("yyyy-MM-dd");
                auditList = _auditService.GetAllAudits(0,0, dateTime, dateTime);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get All Audit", "Audit Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Audit", "Audit Api"));

            return auditList;
        }


        [HttpPost]
        public void SaveAudit(AuditModel auditModel)
        {
            _auditService.SaveAudit(auditModel);
        }

        public List<AuditModel> Get(int userId,int projectId,string dateFrom,string dateTo)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Audit", "Audit Api"));

            List<AuditModel> audits;

            try
            {
                if (dateFrom == null && dateTo == null)
                {
                    dateFrom = DateTime.Now.Date.ToString("yyyy-MM-dd");
                    dateTo = DateTime.Now.Date.ToString("yyyy-MM-dd");
                }

                audits = _auditService.GetAllAudits(userId, projectId, dateFrom, dateTo);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Audit", "Audit Api", ex.Message));

                throw;
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Audit", "Audit Api"));

            return audits;
        }
    }
}