using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
   public class DataSourceKeysConfigurationInputModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSourceKeyId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsPrivate { get; set; }
        public bool? IsTag { get; set; }
        public bool? IsTrendsEnable { get; set; }
    }
}
