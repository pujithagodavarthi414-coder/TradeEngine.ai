using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DataSourceKeysConfigurationModel
    {
        public List<DataSourceKeysConfigurationOutputModel> dataSourceKeys { get; set; }
        public string SelectedKeyIds { get; set; }
        public string SelectedPrivateKeyIds { get; set; }
        public string SelectedEnableTrendsKeys { get; set; }
        public string SelectedTagKeyIds { get; set; }
    }
}
