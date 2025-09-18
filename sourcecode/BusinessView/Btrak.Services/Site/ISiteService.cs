using Btrak.Models;
using Btrak.Models.Site;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Site
{
    public interface ISiteService
    {
        Guid? UpsertSite(SiteUpsertModel siteUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSolorLog(SolorLogModel solorLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SiteOutpuModel> GetSite(SiteOutpuModel siteOutpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SolorLogModel> GetSolorLog(SolorLogModel solorLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
