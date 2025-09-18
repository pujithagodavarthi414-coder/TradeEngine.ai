using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DataSourceHistorySearchInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public bool? IsArchived { get; set; }
    }
}
