
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomApplication
{
    public class CustomFieldMappingApiOutputModel
    {
        public Guid? MappingId { get; set; }

        public string MappingName { get; set; }

        public string MappingJson { get; set; }

        public Guid? CustomApplicationId { get; set; }

        public byte[] TimeStamp { get; set; }
    }
}
