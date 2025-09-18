using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class MasterAccountUpsertInputModel : InputModelBase
    {
        public MasterAccountUpsertInputModel() : base(InputTypeGuidConstants.MasterAccountUpsertInputModelCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public string Account { get; set; }
        public string ClassNo { get; set; }
        public string ClassNoF { get; set; }
        public string Class { get; set; }
        public string ClassF { get; set; }
        public string Group { get; set; }
        public string GroupF { get; set; }
        public string SubGroup { get; set; }
        public string SubGroupF { get; set; }
        public string AccountNo { get; set; }
        public string AccountNoF { get; set; }
        public string Compte { get; set; }
        public bool IsArchived { get; set; }

	}
}
