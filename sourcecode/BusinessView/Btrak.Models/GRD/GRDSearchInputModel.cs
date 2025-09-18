using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class GRDSearchInputModel : SearchCriteriaInputModelBase
    {
        public GRDSearchInputModel() : base(InputTypeGuidConstants.GRDSearchInputCommandTypeGuid)
        {

        }

        public Guid? Id { get; set; }
    }
}
