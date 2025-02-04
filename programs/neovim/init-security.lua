-- DO NOT ALLOW REQUIRING MODULES FROM THE WORKING DIRECTORY!
package.path  = package.path:gsub("./%?.lua;", "")
package.cpath = package.cpath:gsub("./%?.so;", "")
