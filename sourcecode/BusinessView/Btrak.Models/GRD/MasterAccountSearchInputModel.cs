using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class MasterAccountSearchInputModel : SearchCriteriaInputModelBase
    {
        public MasterAccountSearchInputModel() : base(InputTypeGuidConstants.MasterAccountSearchInputModelCommandTypeGuid)
        {
        }
        public Guid? MasterAccountId { get; set; }
    }
}
