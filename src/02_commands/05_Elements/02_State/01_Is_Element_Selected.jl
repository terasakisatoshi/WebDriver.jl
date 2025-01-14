# Command: Is Element Selected
"""
	isselected(element::Element)::Bool

The Is Element Selected command determines if the referenced element is selected or not.
This operation only makes sense on input elements of the Checkbox and Radio Button states, or on option elements.
"""
function isselected(element::Element)::Bool
    @unpack addr, id = element.session
    element_id = element.id
    response = HTTP.get(
        "$addr/session/$id/element/$element_id/selected",
        [("Content-Type" => "application/json; charset=utf-8")],
    )
    @assert response.status == 200
    JSON3.read(response.body).value
end
