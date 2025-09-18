using System.Collections.Generic;

namespace Btrak.Models.Burndown
{
    public class BurnDownChartModel
    {
        public string ContainerId { get; set; }
        public BurnDownConfigModel ConfigModel { get; set; }
        public List<BurnDownDataModel> BurnDownData { get; set; }
    }
}