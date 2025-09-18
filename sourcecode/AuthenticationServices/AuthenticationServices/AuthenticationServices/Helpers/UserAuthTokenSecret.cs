using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace AuthenticationServices.Api.Helpers
{
    public class UserAuthTokenSecret
    {
        IConfiguration _iconfiguration;

        public UserAuthTokenSecret()
        {

        }
        public string GetSecret()
        {
            
            // Return the secret
            return _iconfiguration["AuthTokenSecret"];
        }
    }
}
