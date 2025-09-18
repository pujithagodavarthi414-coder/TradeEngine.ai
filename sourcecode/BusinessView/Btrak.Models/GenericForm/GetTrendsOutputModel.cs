using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GetTrendsOutputModel
    {
        public Guid? TrendId { get; set; }
        public string TrendValue { get; set; }
        public int? UniqueNumber { get; set; }
        public string CustomApplicationName { get; set; }
        public string FormName { get; set; }
        public string Key { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? GenericFormKeyId { get; set; }

    }
}
