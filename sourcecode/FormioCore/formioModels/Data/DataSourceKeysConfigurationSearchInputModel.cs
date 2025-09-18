using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
   public class DataSourceKeysConfigurationSearchInputModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? DataSourceKeyId { get; set; }
        public bool IsOnlyForKeys { get; set; }

    }
}
