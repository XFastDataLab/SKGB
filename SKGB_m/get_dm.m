function mean_radius = get_dm(gb)
    num = size(gb, 1);
    center = mean(gb, 1);
    diff_mat = bsxfun(@minus, center, gb);
    sq_diff_mat = diff_mat .^ 2;
    sq_distances = sum(sq_diff_mat, 2);
    distances = sqrt(sq_distances);
    sum_radius = sum(distances);
    mean_radius = sum_radius / num;
    if num <= 2
        mean_radius = 1;
    end
end
