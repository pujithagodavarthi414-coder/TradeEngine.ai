using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class ESGIndicatorsInputModel
    {
        public Guid? Id { get; set; }
        public bool IsArchived { get; set; }
        public Guid DataSourceId { get; set; }
        public Guid UserIds { get; set; }
        public Guid? ProgramId { get; set; }
        public string Template { get; set; }
        public Guid? KpiId { get; set; }
        public object FormData { get; set; }
        public string FormName { get; set; }
        public bool? IsNewRecord { get; set; }
    }

    public class ESGFormData
    {
        public string kpi01 { get; set; }
        public string targetAreaInThePhase { get; set; }
        public List<string> applicableSdGs1 { get; set; }
        public List<string> applicableEsgIndicators { get; set; }
        public string kpiNumber02 { get; set; }
        public string targetAreaInThePhase1 { get; set; }
        public List<string> applicableSdGsForKpi02 { get; set; }
        public List<string> applicableEsgIndicators1 { get; set; }
        public string kpiNumber03 { get; set; }
        public string targetAreaInThePhase2 { get; set; }
        public List<string> applicableSdGsForKpi03 { get; set; }
        public List<string> applicableEsgIndicators2 { get; set; }
        public string phase { get; set; }
        public string phase1 { get; set; }
        public string phase2 { get; set; }
        public string phaseNumber3 { get; set; }
        public string phaseNumber4 { get; set; }
        public string phaseNumber5 { get; set; }
        public string targetForKpi02 { get; set; }
        public string targetKpi01 { get; set; }
        public string targetKpi02 { get; set; }
        public string targetShFs { get; set; }
        public string targetShFs1 { get; set; }
        public string targetShFs2 { get; set; }
        public string taskForAchievingKpi03 { get; set; }
        public string taskForAchievingTargetKpi01 { get; set; }
        public string taskForAchievingTargetKpi02 { get; set; }
        public string selectValidator { get; set; }
    }
}
