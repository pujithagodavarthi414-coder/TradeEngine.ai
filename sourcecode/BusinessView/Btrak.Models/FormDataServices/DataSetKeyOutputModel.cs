using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
   public class DataSetKeyOutputModel
    {
        public Guid? Id { get; set; }
        public string DataSourceName { get; set; }
        public string Key { get; set; }
        public DataSetConversionModel DataJson { get; set; }
    }
}
