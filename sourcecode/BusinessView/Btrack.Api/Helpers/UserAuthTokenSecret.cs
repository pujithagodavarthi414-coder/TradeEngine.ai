using System.Configuration;

namespace BTrak.Api.Helpers
{
    public class UserAuthTokenSecret
    {
        /// <summary>
        /// Gets the secret.
        /// </summary>
        /// <returns>Secret Key</returns>
        public string GetSecret()
        {
            // Return the secret
            return ConfigurationManager.AppSettings["AuthTokenSecret"];
        }
    }
}