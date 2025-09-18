using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DataSourceKeysSearchInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string SearchText { get; set; }
        public string FormIdsString { get; set; }
        public bool IsOnlyForKeys { get; set; }
        public string Type { get; set; }
    }
}
