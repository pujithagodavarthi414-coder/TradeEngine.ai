using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Claims;
using System.Text.Json;
using Dapper;
using IdentityModel;
using IdentityServer.Models;
using IdentityServer4;
using IdentityServer4.Models;
using IdentityServer4.Test;
using Microsoft.Data.SqlClient;

namespace IdentityServer
{
    public static class Config
    {
        public static IEnumerable<ApiScope> ApiScopes =>
            new List<ApiScope>
            {
                new ApiScope("api1", "My API"),
                new ApiScope("UserName", "UserName")
            };

        public static List<string> scops = new List<string>()
        {
            new string("api1"),
            new string("UserName")
        };

        public static IEnumerable<Client> Clients =>
            new List<Client>
            {
                new Client
                {
                    ClientId = "client",

                    // no interactive user, use the clientid/secret for authentication
                    AllowedGrantTypes = GrantTypes.ClientCredentials,

                    // secret for authentication
                    ClientSecrets =
                    {
                        new Secret("secret".Sha256())
                    },

                    // scopes that client has access to
                    
                    //AllowedScopes =
                    //{
                    //    "api1",
                    //    "UserName"
                    //},
                    AllowedScopes = scops
                }
            };

        public static List<TestUser> Users
        {
            get
            {
                var address = new
                {
                    street_address = "One Hacker Way",
                    locality = "Heidelberg",
                    postal_code = 69118,
                    country = "Germany"
                };

                return new List<TestUser>
                {
                    new TestUser
                    {
                        SubjectId = "818727",
                        Username = "alice",
                        Password = "alice",
                        Claims =
                        {
                            new Claim(JwtClaimTypes.Name, "Alice Smith"),
                            new Claim(JwtClaimTypes.GivenName, "Alice"),
                            new Claim(JwtClaimTypes.FamilyName, "Smith"),
                            new Claim(JwtClaimTypes.Email, "AliceSmith@email.com"),
                            new Claim(JwtClaimTypes.EmailVerified, "true", ClaimValueTypes.Boolean),
                            new Claim(JwtClaimTypes.Role, "admin"),
                            new Claim(JwtClaimTypes.WebSite, "http://alice.com"),
                            new Claim(JwtClaimTypes.Address, JsonSerializer.Serialize(address),
                                IdentityServerConstants.ClaimValueTypes.Json)
                        }
                    },
                    new TestUser
                    {
                        SubjectId = "88421113",
                        Username = "bob",
                        Password = "bob",
                        Claims =
                        {
                            new Claim(JwtClaimTypes.Name, "Bob Smith"),
                            new Claim(JwtClaimTypes.GivenName, "Bob"),
                            new Claim(JwtClaimTypes.FamilyName, "Smith"),
                            new Claim(JwtClaimTypes.Email, "BobSmith@email.com"),
                            new Claim(JwtClaimTypes.EmailVerified, "true", ClaimValueTypes.Boolean),
                            new Claim(JwtClaimTypes.Role, "user"),
                            new Claim(JwtClaimTypes.WebSite, "http://bob.com"),
                            new Claim(JwtClaimTypes.Address, JsonSerializer.Serialize(address),
                                IdentityServerConstants.ClaimValueTypes.Json)
                        }
                    }
                };
            }
        }



        public static List<TestUser> UserList(string connectionString)
        {
            var userList = GetUserList(connectionString);
            if (userList != null && userList.Count() > 0)
            {
                var retunUserList = new List<TestUser>();
                foreach (var user in userList)
                {
                    retunUserList.Add(new TestUser
                    {
                        SubjectId = user.UserId.ToString(),
                        Username = user.FullName,
                        Password = user.Password,
                        IsActive = user.IsActive == null ? false : (bool)user.IsActive,
                        Claims =
                        {
                            new Claim("UserId", user.UserId.ToString()),
                            new Claim("CompanyId", user.CompanyId.ToString())
                        }
                    });
                }
                return retunUserList;
            }
            return null;
        }

        public static IEnumerable<Client> GetClients(string connectionString)
        {
            var userList = GetUserList(connectionString);
            if (userList != null && userList.Count() > 0)
            {
                var clientList = new List<Client>();
                foreach (var user in userList)
                {
                    clientList.Add(new Client
                    {
                        ClientId = user.UserId.ToString().ToLower() +" "+ user.CompanyId.ToString().ToLower(),

                        AllowedGrantTypes = GrantTypes.ClientCredentials,

                        // secret for authentication
                        ClientSecrets =
                        {
                            new Secret("secret".Sha256())
                        },

                        AllowedScopes = { user.CompanyId.ToString().ToLower() }
                    });
                }
                return clientList;
            }
            return null;
        }

        public static IEnumerable<ApiScope> GetScopes(string connectionString)
        {
            var userList = GetUserList(connectionString);
            if (userList != null && userList.Count() > 0)
            {
                var scopesList = new List<ApiScope>();
                foreach (var user in userList)
                {
                    scopesList.Add(new ApiScope
                    {
                        Name = user.CompanyId.ToString(),
                        DisplayName = "CompanyName"
                    });
                }
                return scopesList;
            }
            else
            {
                return new List<ApiScope>
                {
                    new ApiScope("api1", "My API"),
                    new ApiScope("UserName", "UserName")
                };
            }
        }

        public static List<UserOutputModel> GetUserList(string connectionString)
        {
            try
            {
                using (var vConn = OpenConnection(connectionString))
                {
                    var vParams = new DynamicParameters();
                    return vConn.Query<UserOutputModel>("USP_GetAllUsersForAuthentication", vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                return null;
            }
        }

        public static IDbConnection OpenConnection(string connectionString)
        {
            //var value1 = _appSettings.BTrakConnectionString;
            IDbConnection connection = new SqlConnection(connectionString);
            connection.Open();
            return connection;
        }

        public static IEnumerable<IdentityResource> IdentityResources =>
            new[]
            {
                new IdentityResources.OpenId(),
                new IdentityResources.Profile(),
                new IdentityResource
                {
                    Name = "role",
                    UserClaims = new List<string> {"role"}
                }
            };
    }
}
