using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class UserDataSetRelationModel
    {
        public List<Guid> UserId { get; set; }
        public List<Guid> DataSetIds { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
