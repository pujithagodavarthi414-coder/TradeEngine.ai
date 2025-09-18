using Btrak.Models.CompanyStructure;
using Btrak.Models.MasterData;
using Btrak.Models.Role;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.Widgets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.User
{
  public class InitialDetailsOutputModel
  {
    public string AuthToken { get; set; }
     public Guid? DefaultAppId { get; set; }
     public UsersModel UsersModel { get; set; }
    public WorkspaceApiReturnModel DefaultDashboardId { get; set; }
    public List<WorkspaceApiReturnModel> Dashboards { get; set; }
    public CompanyOutputModel CompanyDetails { get; set; }
    public List<RoleFeatureApiReturnModel> RoleFeatures { get; set; }
    public List<SoftLabelApiReturnModel> SoftLabels { get; set; }
    public List<CompanySettingsSearchOutputModel> CompanySettings { get; set; }
    public UserAuthToken UserAuthToken { get; set; }
    }
}
