

using System;
using System.Text;

namespace Btrak.Models.W3rt
{
    public class OrganisationOutputModel
    {
        
        public Guid OrganisationId { get; set; }
        public string OrganisationName { get; set; }
        public string Description { get; set; }
        public string AddressJson { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string ImageJson { get; set; }
        public string Town { get; set; }
        public string Locality { get; set; }
      

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("OrganisationId" + OrganisationId);
            stringBuilder.Append("OrganisationName" + OrganisationName);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("AddressJson" + AddressJson);
            stringBuilder.Append("PhoneNumber" + PhoneNumber);
            stringBuilder.Append("Email" + Email);
            stringBuilder.Append("ImageJson" + ImageJson);
            stringBuilder.Append("Town" + Town);
            stringBuilder.Append("Locality" + Locality);
            return base.ToString();
        }
    }
}
