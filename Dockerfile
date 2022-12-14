FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY BulkyBookWeb/. ./BulkyBookWeb/
COPY BulkyBookWeb.UnitTests/. ./BulkyBookWeb.UnitTests/
RUN dotnet restore

# copy everything else and build app

WORKDIR /source
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./

#EXPOSE 5000

ENTRYPOINT ["dotnet", "BulkyBookWeb.dll"]