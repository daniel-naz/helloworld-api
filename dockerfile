# ---- build ----
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# ---- run ----
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Coolify will route traffic to this port
EXPOSE 8080
ENV ASPNETCORE_URLS=http://0.0.0.0:8080

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "helloworld.dll"]