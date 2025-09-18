using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Site;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Site;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Site
{
    public class SiteService : ISiteService
    {
        private readonly SiteRepository _siteRepository;
        private readonly IAuditService _auditService;

        public SiteService(SiteRepository siteRepository, IAuditService auditService)
        {
            _siteRepository = siteRepository;
            _auditService = auditService;
        }

        public Guid? UpsertSite(SiteUpsertModel siteUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSite", "SiteService"));

            LoggingManager.Debug(siteUpsertModel.ToString());

            if (!SiteValidationHelper.UpsertSiteValidations(siteUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }
            siteUpsertModel.Id = _siteRepository.UpsertSite(siteUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, siteUpsertModel, loggedInContext);

            LoggingManager.Debug(siteUpsertModel.Id?.ToString());

            return siteUpsertModel.Id;
        }

        public List<SiteOutpuModel> GetSite(SiteOutpuModel siteOutpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSite", "SiteService"));

            _auditService.SaveAudit(AppCommandConstants.GetSiteCommandId, siteOutpuModel, loggedInContext);

            //if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            List<SiteOutpuModel> siteOutpuModels = _siteRepository.GetSite(siteOutpuModel, loggedInContext, validationMessages).ToList();

            return siteOutpuModels;
        }


        public Guid? UpsertSolorLog(SolorLogModel solorLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSite", "SiteService"));

            LoggingManager.Debug(solorLogModel.ToString());

            //if (!SiteValidationHelper.UpsertSiteValidations(siteUpsertModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}
            solorLogModel.SolarId = _siteRepository.UpsertSolorLog(solorLogModel, loggedInContext, validationMessages);

            return solorLogModel.SolarId;
        }


        public List<SolorLogModel> GetSolorLog(SolorLogModel solorLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSite", "SiteService"));

            _auditService.SaveAudit(AppCommandConstants.GetSiteCommandId, solorLogModel, loggedInContext);

            List<SolorLogModel> solorLogList = _siteRepository.GetSolorLog(solorLogModel, loggedInContext, validationMessages).ToList();

            foreach(var solar in solorLogList)
            {
                if(solar.SolarLogValue != null)
                {
                    solar.SolarLogValueString = Convert.ToDouble(solar.SolarLogValue).ToString("N0");
                    solar.SolarLogValueMutipleString = Convert.ToDouble(solar.SolarLogValue*1000).ToString("N0");
                }
            }

            return solorLogList;
        }

        public Guid? UpsertGridForSiteProjection(GridForSiteProjectionModel gridForSiteProjectionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGridForSiteProjection", "SiteService"));

            LoggingManager.Debug(gridForSiteProjectionModel.ToString());

            gridForSiteProjectionModel.GridForSiteProjectionId = _siteRepository.UpsertGridForSiteProjection(gridForSiteProjectionModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBranchCommandId, gridForSiteProjectionModel, loggedInContext);

            LoggingManager.Debug(gridForSiteProjectionModel.GridForSiteProjectionId?.ToString());

            return gridForSiteProjectionModel.GridForSiteProjectionId;
        }

        public List<GridForSiteProjectionModel> GetGridForSiteProjection(GridForSiteProjectionModel gridForSiteProjectionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGridForSiteProjection", "SiteService"));

            _auditService.SaveAudit(AppCommandConstants.GetSiteCommandId, gridForSiteProjectionModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GridForSiteProjectionModel> gridForSiteProjections = _siteRepository.GetGridForSiteProjection(gridForSiteProjectionModel, loggedInContext, validationMessages).ToList();

            return gridForSiteProjections;
        }
    }
}
