using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomApplication
{
   public class CustomApplicationTagInputModel
    {
        public Guid? Id { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public string KeyValue { get; set; }
        public bool? IsTag { get; set; }
    }
}
