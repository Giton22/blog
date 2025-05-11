import { FC, ReactNode } from "react";

interface SectionContentProps {
    title: string;
    children: ReactNode;
    containerClassName?: string;
    titleClassName?: string;
}

const SectionContent: FC<SectionContentProps> = ({
    title,
    children,
    containerClassName,
    titleClassName = "text-lg font-semibold",
}) => (
    <div className={containerClassName}>
        <h2 className={titleClassName}>{title}</h2>
        {children}
    </div>
);

export default SectionContent;
