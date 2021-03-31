update map_context ct
    join  map_node n on n.id = ct.node
    join  concept cp on cp.dbid = n.concept
    set cp.name = ct.column
where ct.draft=1 and n.draft=1 and cp.draft=1;

update  map_context ct
    join  map_node n on n.id = ct.node
    join  concept cp on cp.dbid = n.concept
    join  map_value_node vn on vn.node = n.id
    join  map_value_node_lookup l on l.value_node = vn.id
    join  concept v on v.dbid = l.concept
    set v.name = concat(cp.name,"=",l.value)
where l.draft = 1;