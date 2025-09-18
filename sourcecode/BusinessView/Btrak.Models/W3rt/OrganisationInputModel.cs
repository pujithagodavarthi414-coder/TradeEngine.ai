using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.W3rt
{
    public class OrganisationInputModel: SearchCriteriaInputModelBase
    {
        public OrganisationInputModel() : base(InputTypeGuidConstants.OrganisationInputCommandTypeGuid)
        {
        }
        //public Guid? Id { get; set; }
        public Nullable<Guid> OrganisationId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            //stringBuilder.Append("Id" + Id);
           stringBuilder.Append("OrganisationId" + OrganisationId);

            return base.ToString();
        }
    }
}
