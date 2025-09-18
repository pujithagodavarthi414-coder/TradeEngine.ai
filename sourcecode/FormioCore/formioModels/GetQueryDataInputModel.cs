using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class GetQueryDataInputModel
    {
        public string MongoQuery { get; set; }
        public bool? IsQueryHeaders { get; set; }
        public string CollectionName { get; set; }
    }
}
